import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:image_gallery_saver_plus/image_gallery_saver_plus.dart';
import 'package:semesta/public/extensions/string_extension.dart';
import 'package:semesta/public/functions/func_helper.dart';
import 'package:semesta/public/mixins/filer_mixin.dart';
import 'package:semesta/app/models/media.dart';
import 'package:semesta/app/services/firebase_service.dart';
import 'package:semesta/public/utils/type_def.dart';

enum StoredIn { avatar, image, video, cover, thumbnail }

abstract class IStorageService extends FirebaseService with FilerMixin {
  final _dio = Dio();

  /// Upload a file and return its public download URL
  Wait<Media> uploadFile(File file, String folderName, String fileName) {
    return handler(() async {
      final path = '$folderName/$fileName';

      // Upload file to Firebase Storage
      final uploadTask = await ud.ref(path).putFile(file);

      // Get download URL
      final downloadUrl = await uploadTask.ref.getDownloadURL();

      return Media(
        display: downloadUrl,
        path: path,
        type: parseEnum(folderName, MediaType.values, MediaType.image),
      );
    }, message: "Failed to upload");
  }

  /// Get a file's public download URL if you already know its path
  AsWait downloadFile(
    String path, [
    void Function(int received, int total)? onProgress,
  ]) => handler(() async {
    // Permission
    final status = await requestPermissions();
    if (!status) throw StateError('Permission denied');

    // Resolve Firebase URL
    final url = await ud.ref(path).getDownloadURL();
    if (url.isEmpty) return;

    // Download
    final res = await _dio.get(
      url,
      onReceiveProgress: onProgress,
      options: Options(responseType: ResponseType.bytes, followRedirects: true),
    );

    // Save to gallery
    final state = await ImageGallerySaverPlus.saveImage(
      Uint8List.fromList(res.data),
      quality: 100,
      isReturnImagePathOfIOS: true,
      name: url.contains('.mp4') ? 'VIDEO'.toName : 'IMAGE'.toName,
    );

    // Feedback
    if (state["isSuccess"] == false) throw StateError('Failed to save image');
  }, message: "Failed to download");

  /// Delete a file by its storage path
  AsWait deleteFile(String path) {
    return handler(() => ud.ref(path).delete(), message: "Failed to delete");
  }
}
