import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:semesta/app/services/firebase_service.dart';
import 'package:semesta/public/functions/func_helper.dart';
import 'package:semesta/public/functions/logger.dart';
import 'package:semesta/public/helpers/generic_helper.dart';
import 'package:semesta/public/utils/type_def.dart';
import 'package:semesta/app/models/reaction.dart';

enum QueryMode { normal, next, refresh }

typedef Runs<T> = AsWait Function(T run);

mixin RepositoryMixin<T> on FirebaseService {
  final Mapper<T> _cache = {};

  void clearCached(String id) {
    _cache.removeWhere((key, _) => key.contains(id));
  }

  /// Returns the Firestore collection colName
  String get colName;

  /// Convert model -> Firestore map
  AsMap toPayload(T model);

  /// Convert Firestore doc -> model
  T fromState(AsMap map);

  /// Get document by ID
  Wait<T?> show(String id) async {
    if (_cache.containsKey(id)) return _cache[id];

    final res = getOne(await collection(colName).doc(id).get(), fromState);
    _cache[id] = res;

    return res;
  }

  /// Get document by ID or USERNAME
  Wait<T?> view(String id, {String other = '', String key = 'uname'}) async {
    if (other.isEmpty) return show(id);

    if (_cache.containsKey(other)) return _cache[other];
    final res = await collection(colName)
        .limit(1)
        .where(key, isEqualTo: other)
        .get()
        .then((value) => getOne(value.docs[0], fromState));
    _cache[other] = res;

    return res;
  }

  /// Get all documents (basic)
  Waits<T> index({
    int limit = 20,
    bool descending = true,
    String orderKey = made,
    QueryMode mode = QueryMode.normal,
  }) => collection(colName)
      .orderBy(orderKey, descending: descending)
      .limit(mode == QueryMode.refresh ? 100 : limit)
      .get()
      .then((value) => getMore(value, fromState));

  /// Get all documents (anvanced)
  Waits<T> subindex({
    int limit = 20,
    String col = comments,
    bool descending = true,
    String orderKey = made,
    QueryMode mode = QueryMode.normal,
  }) => subcollection(col)
      .orderBy(orderKey, descending: descending)
      .limit(mode == QueryMode.refresh ? 100 : limit)
      .get()
      .then((value) => getMore(value, fromState));

  /// Advanced query with multiple conditions
  Waits<T> query(
    AsMap conditions, {
    int limit = 20,
    String orderKey = made,
    bool descending = true,
    QueryMode mode = QueryMode.normal,
  }) async {
    Query<AsMap> res = collection(colName)
        .orderBy(orderKey, descending: descending)
        .limit(mode == QueryMode.refresh ? 100 : limit);

    // Apply multiple where conditions
    conditions.forEach((key, value) {
      if (value is List) {
        res = res.where(key, whereIn: value);
      } else {
        res = res.where(key, isEqualTo: value);
      }
    });

    // Execute query
    return getMore(await res.get(), fromState);
  }

  Sync<T> sync$(String doc) {
    assert(doc.isNotEmpty, 'Document ID must not be empty');
    return handler(
      () => collection(colName).doc(doc).snapshots().map((doc) {
        return getOne(doc, fromState);
      }),
      message: 'Failed to stream data in: $doc',
    );
  }

  SyncDoc<AsMap> syncDoc$(String doc) {
    return document(doc).snapshots();
  }

  Sync<bool> has$(String doc) {
    return document(doc).snapshots().map((d) => d.exists);
  }

  CollectionReference<AsMap> collection(String col) => db.collection(col);
  Query<AsMap> subcollection(String col) {
    assert(col.isNotEmpty, 'Collection must not be empty');
    return db.collectionGroup(col);
  }

  DocumentReference<AsMap> document(String doc) {
    assert(!doc.contains('//'));
    return db.doc(doc);
  }

  AsWait submit(Runs<WriteBatch> start) => handler(() async {
    await start(db.batch());
  }, message: 'Failed to submit batch operation');

  AsWait execute(Runs<Transaction> start) {
    return db.runTransaction(start).onError((e, s) {
      HandleLogger.error('Transaction $T', error: e, stack: s);
      throw Exception('Transaction failed: ${e.toString()}');
    });
  }

  Wait callable(String name, [AsMap params = const {}]) async {
    final data = await fn.httpsCallable(name).call(params);
    print("The Data: ${data.data}");
  }

  Waits<T> getInOrder(
    AsList values, {
    int limit = 20,
    QueryMode mode = QueryMode.normal,
  }) async {
    if (values.isEmpty) return const [];

    return collection(colName)
        .where(FieldPath.documentId, whereIn: values)
        .limit(mode == QueryMode.refresh ? 100 : limit)
        .get()
        .then((value) => getSelected(values, value, fromState));
  }

  Waits<T> getInSuborder(
    AsList values, {
    int limit = 20,
    String key = keyId,
    String col = comments,
    QueryMode mode = QueryMode.normal,
  }) async {
    if (values.isEmpty) return const [];

    return subcollection(col)
        .where(key, whereIn: values)
        .limit(mode == QueryMode.refresh ? 100 : limit)
        .get()
        .then((value) => getSelected(values, value, fromState));
  }

  Waits<Reaction> getReactions(
    AsMap conditions, {
    int limit = 30,
    String orderKey = made,
    String col = followers,
    bool descending = true,
    QueryMode mode = QueryMode.normal,
  }) async {
    assert(col.isNotEmpty, 'Collection and Document ID must not be empty');

    Query<AsMap> res = subcollection(col)
        .orderBy(orderKey, descending: descending)
        .limit(mode == QueryMode.refresh ? 100 : limit);

    // Apply multiple where conditions
    conditions.forEach((key, value) {
      if (value is List) {
        res = res.where(key, whereIn: value);
      } else {
        res = res.where(key, isEqualTo: value);
      }
    });

    // Execute query
    return getMore(await res.get(), Reaction.fromState);
  }

  Waits<T> getInGrouped(
    AsMap conditions, {
    int limit = 20,
    String col = comments,
    String orderKey = made,
    bool descending = true,
    QueryMode mode = QueryMode.normal,
  }) async {
    assert(col.isNotEmpty, 'Collection and Document ID must not be empty');

    Query<AsMap> res = subcollection(col)
        .orderBy(orderKey, descending: descending)
        .limit(mode == QueryMode.refresh ? 100 : limit);

    // Apply multiple where conditions
    conditions.forEach((key, value) {
      if (value is List) {
        res = res.where(key, whereIn: value);
      } else {
        res = res.where(key, isEqualTo: value);
      }
    });

    // Execute query
    return getMore(await res.get(), fromState);
  }
}
