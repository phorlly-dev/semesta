import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:semesta/app/utils/logger.dart';

class FileHelper {
  /// Pick one or multiple files (image, video, etc.)
  static Future<List<File>?> pickFiles({
    List<String>? allowedExtensions,
    bool allowMultiple = false,
  }) async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: allowedExtensions == null ? FileType.any : FileType.custom,
        allowMultiple: allowMultiple,
        allowedExtensions: allowedExtensions,
        withData: false,
      );

      if (result == null || result.files.isEmpty) return null;

      return result.paths.map((p) => File(p!)).toList();
    } catch (e, s) {
      HandleLogger.err(
        'Picker files',
        error: 'Error picking files: $e',
        stack: s,
      );

      return null;
    }
  }

  /// Pick a single image file
  static Future<File?> pickImage() async {
    final files = await pickFiles(
      allowedExtensions: ['jpg', 'jpeg', 'png', 'webp'],
    );

    return files?.first;
  }

  /// Pick a single video file
  static Future<File?> pickVideo() async {
    final files = await pickFiles(
      allowedExtensions: ['mp4', 'mov', 'avi', 'mkv'],
    );

    return files?.first;
  }

  /// Validate file size (in MB)
  static bool isFileSizeValid(File file, {double maxMB = 10}) {
    final bytes = file.lengthSync();
    final sizeInMB = bytes / (1024 * 1024);

    return sizeInMB <= maxMB;
  }

  /// Get file name without path
  static String getFileName(File file) =>
      file.path.split(Platform.pathSeparator).last;

  /// Get file extension
  static String getExtension(File file) =>
      file.path.split('.').last.toLowerCase();
}
