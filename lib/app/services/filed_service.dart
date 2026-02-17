import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:semesta/public/functions/custom_toast.dart';
import 'package:semesta/public/functions/func_helper.dart';
import 'package:semesta/public/utils/type_def.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';
import 'package:wechat_camera_picker/wechat_camera_picker.dart'
    hide ImageFormat;

abstract mixin class IFiledService {
  /// Pick one or multiple files (image, video, etc.)
  Waits<File> pickFiles({
    AsList? allowedExtensions,
    bool allowMultiple = false,
  }) => handler(() async {
    final result = await FilePicker.platform.pickFiles(
      type: allowedExtensions == null ? FileType.image : FileType.custom,
      allowMultiple: allowMultiple,
      allowedExtensions: allowedExtensions,
    );

    // Convert to File list
    return result != null || result?.files.isNotEmpty == true
        ? result!.paths.map((p) => File(p!)).toList()
        : const [];
  }, message: 'Failed to picker files');

  /// Pick a single image file
  Wait<File?> pickImage() async {
    final files = await pickFiles(
      allowedExtensions: ['jpg', 'jpeg', 'png', 'webp'],
    );

    return files.isNotEmpty ? files[0] : null;
  }

  /// Pick a single video file
  Wait<File?> pickVideo() async {
    final files = await pickFiles(
      allowedExtensions: ['mp4', 'mov', 'avi', 'mkv'],
    );

    return files.isNotEmpty ? files[0] : null;
  }

  Wait<AssetEntity?> pickCamera(
    BuildContext context, {
    bool enableRecording = true,
    bool tapRecording = true,
    FlashMode flashMode = FlashMode.off,
    ImageFormatGroup formatGroup = ImageFormatGroup.unknown,
    CameraLensDirection lensDirection = CameraLensDirection.back,
  }) => handler(() async {
    // Check permissions first
    if (!await requestPermissions() && !context.mounted) {
      CustomToast.warning('Camera permission denied');
      return null;
    }

    // Launch camera picker
    final asset = await CameraPicker.pickFromCamera(
      context,
      pickerConfig: CameraPickerConfig(
        enableRecording: enableRecording, // allows photo + video capture
        enableTapRecording: tapRecording,
        preferredFlashMode: flashMode,
        preferredLensDirection: lensDirection,
        imageFormatGroup: formatGroup,
        textDelegate: EnglishCameraPickerTextDelegate(),
      ),
    );

    // User canceled or no media captured
    if (asset == null) {
      CustomToast.info('No media captured');
      return null;
    }

    // Validate file size (optional)
    final file = await asset.file;
    if (file != null && file.lengthSync() > 10 * 1024 * 1024) {
      CustomToast.warning('File must be smaller than 10 MB');
      return null;
    }

    return asset;
  }, message: 'Camera capture failed');

  Wait<bool> requestPermissions() async {
    if (await Permission.photos.isGranted) return true;

    final result = await [Permission.photos, Permission.videos].request();
    return result.values.every((status) => status.isGranted);
  }

  Waits<AssetEntity> pickMedia(BuildContext context, {int max = 10}) {
    return handler(() async {
      if (await requestPermissions() && !context.mounted) {
        CustomToast.warning('Permission denied to access gallery');
        return const [];
      }

      final assets = await AssetPicker.pickAssets(
        context,
        pickerConfig: AssetPickerConfig(maxAssets: max),
      );

      return assets != null && assets.isNotEmpty ? assets : const [];
    }, message: 'Permission denied to access gallery');
  }
}
