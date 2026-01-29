import 'package:cloud_firestore/cloud_firestore.dart';
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
  T from(AsMap map, String id);

  /// Get document by ID
  Wait<T?> show(String id) async {
    final doc = await collection(path).doc(id).get();
    if (!doc.exists) return null;

    return from(doc.data()!, doc.id);
  }

  /// Get all documents (basic)
  Wait<List<T>> index({
    int limit = 20,
    bool descending = true,
    String orderKey = made,
    QueryMode mode = QueryMode.normal,
  }) => collection(path)
      .orderBy(orderKey, descending: descending)
      .limit(mode == QueryMode.refresh ? 100 : limit)
      .get()
      .then((value) {
        return value.docs.map((doc) => from(doc.data(), doc.id)).toList();
      })
      .catchError((error, stackTrace) {
        HandleLogger.error(
          'Failed to fetch all documents',
          message: error,
          stack: stackTrace,
        );

        return <T>[];
      });

  /// Get all documents (anvanced)
  Wait<List<T>> subindex({
    int limit = 20,
    String col = comments,
    bool descending = true,
    String orderKey = made,
    QueryMode mode = QueryMode.normal,
  }) => subcollection(col)
      .orderBy(orderKey, descending: descending)
      .limit(mode == QueryMode.refresh ? 100 : limit)
      .get()
      .then((value) {
        return value.docs.map((doc) => from(doc.data(), doc.id)).toList();
      })
      .catchError((error, stackTrace) {
        HandleLogger.error(
          'Failed to fetch all subdocuments',
          message: error,
          stack: stackTrace,
        );

        return <T>[];
      });

  /// Flexible query builder with optional filtering, ordering, and pagination
  Wait<List<T>> query({
    String? key,
    Object? value,
    int limit = 20,
    String orderKey = made,
    bool descending = true,
    Iterable<Object>? values,
    QueryMode mode = QueryMode.normal,
  }) async {
    Query<AsMap> query = collection(path)
        .orderBy(orderKey, descending: descending)
        .limit(mode == QueryMode.refresh ? 100 : limit);

    // Apply filters
    if (value != null) {
      query = query.where(key ?? keyId, isEqualTo: value);
    } else if (values != null && values.isNotEmpty) {
      query = query.where(key ?? userId, whereIn: values);
    }

    // Execute query
    final snapshot = await query.get();
    return snapshot.docs.map((doc) => from(doc.data(), doc.id)).toList();
  }

  /// Advanced query with multiple conditions
  Wait<List<T>> queryAdvanced({
    int limit = 20,
    String orderKey = made,
    bool descending = true,
    required AsMap conditions,
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

    final snapshot = await query.get();
    return snapshot.docs.map((doc) => from(doc.data(), doc.id)).toList();
  }

  Sync<T> sync$(String doc) {
    assert(doc.isNotEmpty, 'Document ID must not be empty');

    return collection(path)
        .doc(doc)
        .snapshots()
        .map<T>((e) {
          if (!e.exists) throw StateError('Document does not exist');

          return from(e.data()!, e.id);
        })
        .handleError((error) {
          // Log error or provide fallback
          HandleLogger.error('Failed to stream data $doc', message: error);

          throw error;
        });
  }

  Sync<Doc<AsMap>> syncDoc$(String doc) {
    return collection(path).doc(doc).snapshots();
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

  Wait<List<T>> getInOrder(
    AsList values, {
    int limit = 20,
    QueryMode mode = QueryMode.normal,
  }) async {
    if (values.isEmpty) return [];

    final snap = await collection(path)
        .where(FieldPath.documentId, whereIn: values)
        .limit(mode == QueryMode.refresh ? 100 : limit)
        .get();

    final map = {for (var d in snap.docs) d.id: from(d.data(), d.id)};

    // Rebuild list in ACTION order
    return values.where(map.containsKey).map((id) => map[id]!).toList();
  }

  Wait<List<T>> getInSuborder(
    AsList values, {
    int limit = 20,
    String key = keyId,
    String col = comments,
    QueryMode mode = QueryMode.normal,
  }) async {
    if (values.isEmpty) return [];

    final snap = await subcollection(col)
        .where(key, whereIn: values)
        .limit(mode == QueryMode.refresh ? 100 : limit)
        .get();

    final map = {for (var d in snap.docs) d.id: from(d.data(), d.id)};

    // Rebuild list in ACTION order
    return values.where(map.containsKey).map((id) => map[id]!).toList();
  }

  Wait<List<Reaction>> getReactions({
    int limit = 30,
    String orderKey = made,
    String col = followers,
    bool descending = true,
    required AsMap conditions,
  }) {
    assert(col.isNotEmpty, 'Collection and Document ID must not be empty');

    Query<AsMap> query = subcollection(
      col,
    ).orderBy(orderKey, descending: descending).limit(limit);

    // Apply multiple where conditions
    conditions.forEach((key, value) {
      if (value is List) {
        query = query.where(key, whereIn: value);
      } else {
        query = query.where(key, isEqualTo: value);
      }
    });

    return query
        .get()
        .then((value) {
          return value.docs.map((d) => Reaction.from(d.data())).toList();
        })
        .catchError((error) {
          // Log error or provide fallback
          HandleLogger.error('Failed to list to actions', message: error);

          return const <Reaction>[];
        });
  }

  Wait<List<T>> getInGrouped({
    int limit = 20,
    String col = comments,
    String orderKey = made,
    bool descending = true,
    required AsMap conditions,
    QueryMode mode = QueryMode.normal,
  }) {
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

    return query
        .get()
        .then((value) => value.docs.map((e) => from(e.data(), e.id)).toList())
        .catchError((e, s) {
          HandleLogger.error('Failed to load $T', message: e, stack: s);

          return <T>[];
        });
  }
}
