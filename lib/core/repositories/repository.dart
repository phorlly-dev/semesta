import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/streams.dart';
import 'package:semesta/app/utils/type_def.dart';
import 'package:semesta/core/services/firebase_service.dart';

abstract class IRepository<T> extends FirebaseService {
  /// Returns the Firestore collection path
  String get collectionPath;

  /// Convert model -> Firestore map
  AsMap toMap(T model);

  /// Convert Firestore doc -> model
  T fromMap(AsMap map, String id);

  /// Add a new document
  Future<String> store(T model) async {
    final docRef = getPath();
    final newModel = (model as dynamic).copyWith(id: docRef.id);
    await docRef.set(toMap(newModel));

    return docRef.id;
  }

  /// Get document by ID
  Future<T?> show(String id) async {
    final doc = await getPath(child: id).get();
    if (!doc.exists) return null;

    return fromMap(doc.data()!, doc.id);
  }

  /// Update an existing document
  Future<void> modify(String id, AsMap data) async =>
      await getPath(child: id).update(data);

  /// Delete a document
  Future<void> destroy(String id) async => await getPath(child: id).delete();

  /// Get all documents (basic)
  Future<List<T>> index([String field = 'created_at']) async {
    final query = await getCollection.orderBy(field, descending: true).get();

    return query.docs.map((doc) => fromMap(doc.data(), doc.id)).toList();
  }

  Future<List<T>> query({
    String field = '_id',
    Object? value,
    Iterable<Object>? values,
    bool orderBy = true,
    String fieldName = 'created_at',
  }) async {
    Query<AsMap> ref = getCollection;

    if (field.isNotEmpty && value != null) {
      ref = ref.where(field, isEqualTo: value);
    } else if (field.isNotEmpty && values != null) {
      ref = ref.where(field, whereIn: values);
    }

    // ✅ Only order if explicitly enabled
    if (orderBy) {
      ref = ref.orderBy(fieldName, descending: true);
    }

    final snapshot = await ref.get();
    return snapshot.docs.map((doc) => fromMap(doc.data(), doc.id)).toList();
  }

  Stream<T> stream(String child, {String? parent}) {
    return getPath(
      parent: parent,
      child: child,
    ).snapshots().map((e) => fromMap(e.data()!, e.id));
  }

  Future<List<T>> viewByLimit({
    String field = 'created_at',
    int limit = 10,
  }) async {
    final query = await getCollection
        .orderBy(field, descending: true)
        .limit(limit)
        .get();

    return query.docs.map((doc) => fromMap(doc.data(), doc.id)).toList();
  }

  StreamSubscription<DocumentSnapshot<AsMap>> live({
    String? parent,
    required String child,
    void Function(DocumentSnapshot<AsMap> doc)? onStream,
  }) => getPath(child: child, parent: parent).snapshots().listen(onStream);

  Stream<DocumentSnapshot<AsMap>> liveStream({
    String? parent,
    required String child,
  }) => getPath(child: child, parent: parent).snapshots();

  Stream<T> bindStream({
    required StreamDoc<AsMap> first,
    required StreamDoc<AsMap> second,
    required ConbineData<Doc<AsMap>, Doc<AsMap>, T> combiner,
  }) => CombineLatestStream.combine2(first, second, combiner);

  CollectionReference<AsMap> get getCollection =>
      firestore.collection(collectionPath);

  DocumentReference<AsMap> getPath({String? parent, String? child}) =>
      firestore.collection(parent ?? collectionPath).doc(child);

  Future<void> toggleCount({
    required String child,
    String? parent,
    String field = 'posted',
    int delta = 1,
  }) async {
    final ref = getPath(parent: parent, child: child);

    await firestore.runTransaction((txn) async {
      final snap = await txn.get(ref);
      if (!snap.exists) return;

      final currentValue = (snap.data()?['${field}_count'] ?? 0) as num;
      txn.update(ref, {'${field}_count': currentValue + delta});
    });
  }
}
