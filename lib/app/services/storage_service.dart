import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:semesta/app/services/cached_service.dart';
import 'package:semesta/public/functions/func_helper.dart';
import 'package:semesta/app/services/filed_service.dart';
import 'package:semesta/app/models/media.dart';
import 'package:semesta/app/services/firebase_service.dart';
import 'package:semesta/public/utils/type_def.dart';

enum StoredIn { avatar, image, video, cover, thumbnail }

abstract class IStorageService extends FirebaseService
    with IFiledService, ICachedService {
  /// Upload a file and return its public download URL
  Wait<Media> uploadFile(File file, String folderName, String fileName) {
    return handler(() async {
      final path = '$folderName/$fileName';

      // Upload file to Firebase Storage
      final uploadTask = await _ref(path).putFile(file);

      // Get download URL
      final downloadUrl = await uploadTask.ref.getDownloadURL();

      return Media(
        path: path,
        url: downloadUrl,
        type: parseEnum(folderName, MediaType.values),
      );
    }, message: "Failed to upload");
  }

  /// Get a file's public download URL if you already know its path
  AsWait downloadFile(String path, Defox<int, int, void>? onProgress) {
    return handler(() async {
      // Permission
      if (!await requestPermissions()) throw StateError('Permission denied');

      // Resolve Firebase URL
      final url = await _ref(path).getDownloadURL();
      if (url.isEmpty) return;

      // Download
      await getFile(url, onProgress);
    }, message: "Failed to download");
  }

  /// Delete a file by its storage path
  AsWait deleteFile(String path) => handler(() {
    return _ref(path).delete();
  }, message: "Failed to delete");

  Reference _ref(String path) => cache.ref(path);
}
