import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:semesta/app/functions/logger.dart';
import 'package:path/path.dart' as p;
import 'package:semesta/core/mixins/filer_mixin.dart';
import 'package:semesta/core/models/media.dart';
import 'package:semesta/core/services/firebase_service.dart';

abstract class IStorageService extends FirebaseService with FilerMixin {
  // final _dio = Dio();

  /// Upload a file and return its public download URL
  Future<Media?> uploadFile({
    required String folderName,
    required String fileName,
    required File file,
  }) async {
    try {
      final path = '$folderName/$fileName';
      final ref = ud.ref().child(path);

      // Upload file to Firebase Storage
      final uploadTask = await ref.putFile(file);

      // Get download URL
      final downloadUrl = await uploadTask.ref.getDownloadURL();

      return Media(
        display: downloadUrl,
        path: path,
        type: MediaType.values.firstWhere(
          (e) => folderName.contains(e.name),
          orElse: () => MediaType.image,
        ),
      );
    } on FirebaseException catch (e, stack) {
      HandleLogger.error("Failed to upload ", message: e.message, stack: stack);
      rethrow;
    }
  }

  /// Get a file's public download URL if you already know its path
  Future<String> getPublicDownloadUrl(String path) async {
    try {
      final ref = ud.ref().child(path);

      return ref.getDownloadURL();
    } catch (e, stack) {
      HandleLogger.error(
        "Failed to download",
        message: 'Failed to get download URL: $e',
        stack: stack,
      );
      rethrow;
    }
  }

  /// Delete a file by its storage path
  Future<void> deleteFile(String path) async {
    try {
      final ref = ud.ref().child(path);
      await ref.delete();

      HandleLogger.warn(
        "Succeed to delete file",
        message: 'File deleted: $path',
      );
    } catch (e, st) {
      HandleLogger.error("Failed to delete file", message: e, stack: st);
      rethrow;
    }
  }

  // Future<void> saveImageToGallery(
  //   String storagePath, {
  //   void Function(int received, int total)? onProgress,
  // }) async {
  //   try {
  //     // 1️⃣ Permission
  //     final status = await requestPermissions();
  //     if (!status) throw 'Permission denied';

  //     // 2️⃣ Resolve Firebase URL
  //     final url = await getPublicDownloadUrl(storagePath);

  //     // 3️⃣ Temp file
  //     final dir = await getTemporaryDirectory();
  //     final filePath =
  //         '${dir.path}/${DateTime.now().millisecondsSinceEpoch}.jpg';

  //     // 4️⃣ Download
  //     final response = await _dio.get(
  //       url,
  //       onReceiveProgress: onProgress,
  //       options: Options(
  //         responseType: ResponseType.bytes,
  //         followRedirects: true,
  //       ),
  //     );

  //     // 5️⃣ Save to gallery
  //     final success = await ImageGallerySaver.saveImage(
  //       Uint8List.fromList(response.data),
  //       quality: 100,
  //       name: filePath,
  //     );

  //     if (success != true) {
  //       throw 'Failed to save image';
  //     }

  //     // 5️⃣ Feedback
  //     debugPrint('Image saved to gallery');
  //   } catch (e) {
  //     debugPrint('Save image error: $e');
  //     rethrow;
  //   }
  // }

  /// Generate a unique filename with timestamp and optional extension
  String genFileName(String baseName, {File? file}) {
    final extension = p.extension(file?.path ?? '');
    final timestamp = DateTime.now().millisecondsSinceEpoch;

    return '${baseName}_$timestamp$extension';
  }
}
