import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:semesta/app/utils/logger.dart';
import 'package:path/path.dart' as p;
import 'package:semesta/core/services/firebase_service.dart';

class StorageService extends FirebaseService {
  /// Upload a file and return its public download URL
  Future<String> uploadFile({
    required String folderName,
    required String fileName,
    required File file,
  }) async {
    try {
      final ref = storage.ref().child('$folderName/$fileName');

      // Upload file to Firebase Storage
      final uploadTask = await ref.putFile(file);

      // Get download URL
      final downloadUrl = await uploadTask.ref.getDownloadURL();

      return downloadUrl;
    } on FirebaseException catch (e, stack) {
      HandleLogger.err(
        "Failed to upload ",
        error: 'Upload failed: ${e.message}',
        stack: stack,
      );
      rethrow;
    }
  }

  /// Get a file's public download URL if you already know its path
  Future<String> downloadFile(String path) async {
    try {
      final ref = storage.ref().child(path);

      return await ref.getDownloadURL();
    } catch (e, stack) {
      HandleLogger.err(
        "Failed to download ",
        error: 'Failed to get download URL: $e',
        stack: stack,
      );
      rethrow;
    }
  }

  /// Delete a file by its storage path
  Future<void> deleteFile(String path) async {
    try {
      final ref = storage.ref().child(path);
      await ref.delete();

      HandleLogger.warn("Succeed to delete file", error: 'File deleted: $path');
    } catch (e, st) {
      HandleLogger.err("Failed to delete file", error: e, stack: st);
      rethrow;
    }
  }

  /// Generate a unique filename with timestamp and optional extension
  String generateFileName(String baseName, {File? file}) {
    final extension = p.extension(file?.path ?? '');
    final timestamp = DateTime.now().millisecondsSinceEpoch;

    return '${baseName}_$timestamp$extension';
  }
}
