import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:semesta/public/functions/custom_toast.dart';
import 'package:semesta/public/functions/logger.dart';
import 'package:semesta/app/services/firebase_service.dart';
import 'package:semesta/public/utils/type_def.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';
import 'package:wechat_camera_picker/wechat_camera_picker.dart'
    hide ImageFormat;

mixin FilerMixin on FirebaseService {
  /// Pick one or multiple files (image, video, etc.)
  Wait<List<File>?> pickFiles({
    List<String>? allowedExtensions,
    bool allowMultiple = false,
  }) async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: allowedExtensions == null ? FileType.image : FileType.custom,
        allowMultiple: allowMultiple,
        allowedExtensions: allowedExtensions,
      );

      if (result == null || result.files.isEmpty) return null;

      // Convert to File list
      return result.paths.map((p) => File(p!)).toList();
    } catch (e, s) {
      HandleLogger.error(
        'Picker files',
        message: 'Error picking files: $e',
        stack: s,
      );
      return null;
    }
  }

  /// Pick a single image file
  Wait<File?> pickImage() async {
    final files = await pickFiles(
      allowedExtensions: ['jpg', 'jpeg', 'png', 'webp'],
    );

    return files?.first;
  }

  /// Pick a single video file
  Wait<File?> pickVideo() async {
    final files = await pickFiles(
      allowedExtensions: ['mp4', 'mov', 'avi', 'mkv'],
    );

    return files?.first;
  }

  Wait<File?> genThumbnail(File videoFile) async {
    final tempDir = await getTemporaryDirectory();
    final path = await VideoThumbnail.thumbnailFile(
      video: videoFile.path,
      thumbnailPath: tempDir.path,
      imageFormat: ImageFormat.JPEG,
      maxWidth: 720, // keep reasonable
      quality: 75,
      timeMs: 1000, // ⏱️ 1s into the video
    );

    if (path == null) return null;

    return File(path);
  }

  Wait<AssetEntity?> pickFromCamera(BuildContext context) async {
    try {
      // Check permissions first
      final hasPermission = await requestPermissions();
      if (!hasPermission) {
        CustomToast.warning('Camera permission denied');
        return null;
      }

      if (!context.mounted) return null;

      // Launch camera picker
      final asset = await CameraPicker.pickFromCamera(
        context,
        pickerConfig: CameraPickerConfig(
          textDelegate: EnglishCameraPickerTextDelegate(),
          enableRecording: true, // allows photo + video capture
          enableTapRecording: true,
          onlyEnableRecording: false,
          enableAudio: true,
        ),
      );

      // User canceled or no media captured
      if (asset == null) {
        CustomToast.info('No media captured');
        return null;
      }

      // Validate file size (optional)
      final file = await asset.file;
      if (file != null && file.lengthSync() > 5 * 1024 * 1024) {
        CustomToast.warning('File must be smaller than 5 MB');

        return null;
      }

      return asset;
    } catch (e, s) {
      HandleLogger.error('Camera capture failed', message: e, stack: s);
      CustomToast.error('Unable to open camera');

      return null;
    }
  }

  Wait<bool> requestPermissions() async {
    if (await Permission.photos.isGranted) return true;

    final result = await [Permission.photos, Permission.videos].request();

    return result.values.every((status) => status.isGranted);
  }

  Wait<List<AssetEntity>> pickMedia(
    BuildContext context, {
    int max = 10,
  }) async {
    if (await requestPermissions() && context.mounted) {
      final assets = await AssetPicker.pickAssets(
        context,
        pickerConfig: AssetPickerConfig(maxAssets: max),
      );

      if (assets == null || assets.isEmpty) return [];

      // final media = await Wait.wait(assets.map((a) async => await a.file));

      return assets;
    } else {
      CustomToast.warning('Permission denied to access gallery');
      return [];
    }
  }

  bool isUnique(List<AssetEntity> from, List<AssetEntity> to) {
    bool isTrue = false;
    for (final f in from) {
      if (!to.any((t) => t.id == f.id)) {
        isTrue = true;
      }
    }

    return isTrue;
  }

  /// Validate file size (in MB)
  bool isFileSizeValid(File file, {double maxMB = 10}) {
    final bytes = file.lengthSync();
    final sizeInMB = bytes / (1024 * 1024);

    return sizeInMB <= maxMB;
  }

  /// Get file name without path
  String getFileName(File file) => file.path.split(Platform.pathSeparator).last;

  /// Get file extension
  String getExtension(File file) => file.path.split('.').last.toLowerCase();
}
