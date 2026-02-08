import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:semesta/public/functions/func_helper.dart';
import 'package:semesta/public/functions/logger.dart';
import 'package:semesta/public/helpers/generic_helper.dart';
import 'package:semesta/public/utils/type_def.dart';
import 'package:semesta/app/models/reaction.dart';
import 'package:semesta/app/repositories/generic_repository.dart';

enum QueryMode { normal, next, refresh }

mixin RepoMixin<T> on GenericRepository {
  /// Returns the Firestore collection path
  String get path;

  /// Convert model -> Firestore map
  AsMap to(T model);

  /// Convert Firestore doc -> model
  T from(AsMap map);

  /// Get document by ID
  Wait<T?> show(String id) async {
    final res = await collection(path).doc(id).get();
    if (!res.exists) return null;

    return from(res.data()!);
  }

  /// Get all documents (basic)
  Waits<T> index({
    int limit = 20,
    bool descending = true,
    String orderKey = made,
    QueryMode mode = QueryMode.normal,
  }) async {
    final res = await collection(path)
        .orderBy(orderKey, descending: descending)
        .limit(mode == QueryMode.refresh ? 100 : limit)
        .get();

    return res.docs.isNotEmpty ? getList(res, from) : const [];
  }

  /// Get all documents (anvanced)
  Waits<T> subindex({
    int limit = 20,
    String col = comments,
    bool descending = true,
    String orderKey = made,
    QueryMode mode = QueryMode.normal,
  }) async {
    final res = await subcollection(col)
        .orderBy(orderKey, descending: descending)
        .limit(mode == QueryMode.refresh ? 100 : limit)
        .get();

    return res.docs.isNotEmpty ? getList(res, from) : const [];
  }

  /// Advanced query with multiple conditions
  Waits<T> query(
    AsMap conditions, {
    int limit = 20,
    String orderKey = made,
    bool descending = true,
    QueryMode mode = QueryMode.normal,
  }) async {
    Query<AsMap> query = collection(path)
        .orderBy(orderKey, descending: descending)
        .limit(mode == QueryMode.refresh ? 100 : limit);

    // Apply multiple where conditions
    conditions.forEach((key, value) {
      if (value is List) {
        query = query.where(key, whereIn: value);
      } else {
        query = query.where(key, isEqualTo: value);
      }
    });

    // Execute query
    final res = await query.get();
    return res.docs.isNotEmpty ? getList(res, from) : const [];
  }

  Sync<T> sync$(String doc) {
    assert(doc.isNotEmpty, 'Document ID must not be empty');
    return handler(
      () => collection(path).doc(doc).snapshots().map((e) {
        final data = e.data();
        if (data == null) throw StateError('Failed to live data in: $doc');

        return from(data);
      }),
      message: 'Failed to stream data in: $doc',
    );
  }

  SyncDoc<AsMap> syncDoc$(String doc) {
    return document(doc).snapshots();
  }

  Sync<bool> has$(String docPath) {
    return document(docPath).snapshots().map((d) => d.exists);
  }

  CollectionReference<AsMap> collection(String col) => db.collection(col);
  Query<AsMap> subcollection(String col) {
    assert(col.isNotEmpty, 'Collection must not be empty');
    return db.collectionGroup(col);
  }

  DocumentReference<AsMap> document(String docPath) {
    assert(!docPath.contains('//'));
    return db.doc(docPath);
  }

  AsWait execute(Defo<Transaction, AsWait> txs) {
    return db.runTransaction(txs).onError((e, s) {
      HandleLogger.error('Transaction $T', error: e, stack: s);
      throw Exception('Transaction failed: ${e.toString()}');
    });
  }

  Waits<T> getInOrder(
    AsList values, {
    int limit = 20,
    QueryMode mode = QueryMode.normal,
  }) async {
    if (values.isEmpty) return const [];

    final res = await collection(path)
        .where(FieldPath.documentId, whereIn: values)
        .limit(mode == QueryMode.refresh ? 100 : limit)
        .get();

    return res.docs.isNotEmpty ? getSelected(values, res, from) : const [];
  }

  Waits<T> getInSuborder(
    AsList values, {
    int limit = 20,
    String key = keyId,
    String col = comments,
    QueryMode mode = QueryMode.normal,
  }) async {
    if (values.isEmpty) return const [];

    final res = await subcollection(col)
        .where(key, whereIn: values)
        .limit(mode == QueryMode.refresh ? 100 : limit)
        .get();

    return res.docs.isNotEmpty ? getSelected(values, res, from) : const [];
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

    Query<AsMap> query = subcollection(col)
        .orderBy(orderKey, descending: descending)
        .limit(mode == QueryMode.refresh ? 100 : limit);

    // Apply multiple where conditions
    conditions.forEach((key, value) {
      if (value is List) {
        query = query.where(key, whereIn: value);
      } else {
        query = query.where(key, isEqualTo: value);
      }
    });

    // Execute query
    final res = await query.get();
    return res.docs.isNotEmpty ? getList(res, Reaction.from) : const [];
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

    Query<AsMap> query = subcollection(col)
        .orderBy(orderKey, descending: descending)
        .limit(mode == QueryMode.refresh ? 100 : limit);

    // Apply multiple where conditions
    conditions.forEach((key, value) {
      if (value is List) {
        query = query.where(key, whereIn: value);
      } else {
        query = query.where(key, isEqualTo: value);
      }
    });

    // Execute query
    final res = await query.get();
    return res.docs.isNotEmpty ? getList(res, from) : const [];
  }
}
