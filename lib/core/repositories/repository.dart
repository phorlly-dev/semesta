import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:semesta/core/services/storage_service.dart';

abstract class IRepository<T> extends StorageService {
  /// Returns the Firestore collection path
  String get collectionPath;

  /// Convert model -> Firestore map
  Map<String, dynamic> toMap(T model);

  /// Convert Firestore doc -> model
  T fromMap(Map<String, dynamic> map, String id);

  /// Add a new document
  Future<String> store(T model) async {
    final docRef = firestore.collection(collectionPath).doc();
    final newModel = (model as dynamic).copyWith(id: docRef.id);
    await docRef.set(toMap(newModel));

    return docRef.id;
  }

  /// Get document by ID
  Future<T?> show(String id) async {
    final doc = await firestore.collection(collectionPath).doc(id).get();
    if (!doc.exists) return null;

    return fromMap(doc.data()!, doc.id);
  }

  /// Update an existing document
  Future<void> modify(String id, Map<String, dynamic> data) async {
    await firestore.collection(collectionPath).doc(id).update(data);
  }

  /// Delete a document
  Future<void> destroy(String id) async {
    await firestore.collection(collectionPath).doc(id).delete();
  }

  /// Get all documents (basic)
  Future<List<T>> index() async {
    final query = await firestore.collection(collectionPath).get();

    return query.docs.map((doc) => fromMap(doc.data(), doc.id)).toList();
  }

  Future<List<T>> query({String? field, dynamic value}) async {
    Query<Map<String, dynamic>> ref = firestore.collection(collectionPath);
    if (field != null && value != null) {
      ref = ref.where(field, isEqualTo: value);
    }

    final snapshot = await ref.get();
    return snapshot.docs.map((doc) => fromMap(doc.data(), doc.id)).toList();
  }

  Future<List<T>> viewByLimit({
    String field = 'created_at',
    int limit = 10,
  }) async {
    final query = await firestore
        .collection(collectionPath)
        .orderBy(field, descending: true)
        .limit(limit)
        .get();

    return query.docs.map((doc) => fromMap(doc.data(), doc.id)).toList();
  }

  final _rand = Random();
  String getRandom(List<String> items) {
    if (items.isEmpty) return 'unknown';
    return items[_rand.nextInt(items.length)];
  }

  Future<String?> uploadProfile(String path, File file) async {
    return uploadFile(
      folderName: '$profiles/$path',
      file: file,
      fileName: generateFileName('avatar', file: file),
    );
  }

  Future<String?> uploadImage(String path, File file) async {
    return uploadFile(
      folderName: '$photos/$path',
      file: file,
      fileName: generateFileName('image', file: file),
    );
  }

  Future<String?> uploadVideo(String path, File file) async {
    return uploadFile(
      folderName: '$videos/$path',
      file: file,
      fileName: generateFileName('video', file: file),
    );
  }
}
