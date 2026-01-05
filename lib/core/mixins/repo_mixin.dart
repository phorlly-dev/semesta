import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:semesta/app/functions/logger.dart';
import 'package:semesta/app/utils/type_def.dart';
import 'package:semesta/core/repositories/generic_repository.dart';

enum QueryMode { normal, next, refresh }

mixin RepoMixin<T> on GenericRepository {
  /// Returns the Firestore collection path
  String get path;

  /// Convert model -> Firestore map
  AsMap to(T model);

  /// Convert Firestore doc -> model
  T from(AsMap map, String id);

  /// Add a new document
  Future<String> store(T model) async {
    final docRef = collection(path).doc();
    final newModel = (model as dynamic).copy(id: docRef.id);
    await docRef.set(to(newModel));

    return docRef.id;
  }

  /// Get document by ID
  Future<T?> show(String id) async {
    final doc = await collection(path).doc(id).get();
    if (!doc.exists) return null;

    return from(doc.data()!, doc.id);
  }

  /// Update an existing document
  Future<void> modify(String id, AsMap data) {
    return collection(path).doc(id).update(data);
  }

  /// Delete a document
  Future<void> destroy(String id) => collection(path).doc(id).delete();

  /// Get all documents (basic)
  Future<List<T>> index({
    int limit = 20,
    bool descending = true,
    String orderKey = 'created_at',
    QueryMode mode = QueryMode.normal,
  }) {
    return collection(path)
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
  }

  /// Flexible query builder with optional filtering, ordering, and pagination
  Future<List<T>> query({
    String? key,
    Object? value,
    Iterable<Object>? values,
    String orderKey = 'created_at',
    bool descending = true,
    int limit = 20,
    QueryMode mode = QueryMode.normal,
  }) async {
    Query<AsMap> query = collection(path)
        .orderBy(orderKey, descending: descending)
        .limit(mode == QueryMode.refresh ? 100 : limit);

    // Apply filters
    if (value != null) {
      query = query.where(key ?? 'id', isEqualTo: value);
    } else if (values != null && values.isNotEmpty) {
      query = query.where(key ?? 'uid', whereIn: values);
    }

    // Execute query
    final snapshot = await query.get();
    return snapshot.docs.map((doc) => from(doc.data(), doc.id)).toList();
  }

  /// Advanced query with multiple conditions
  Future<List<T>> queryAdvanced({
    required AsMap conditions,
    String orderKey = 'created_at',
    bool descending = true,
    int limit = 20,
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

  CollectionReference<AsMap> collection(String col) => db.collection(col);
  Query<AsMap> subcollection(String col) {
    assert(col.isNotEmpty, 'Collection must not be empty');
    return db.collectionGroup(col);
  }

  DocumentReference<AsMap> document(String docPath) {
    assert(!docPath.contains('//'));
    return db.doc(docPath);
  }
}
