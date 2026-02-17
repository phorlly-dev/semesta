import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:semesta/app/services/storage_service.dart';
import 'package:semesta/public/extensions/string_extension.dart';

extension FileX on File {
  /// Get file name without path
  String get getName => path.split(Platform.pathSeparator).last;

  /// Get file extension
  String get getExtension => path.split('.').last.toLowerCase();

  /// Validate file size (in MB)
  bool maxSize([double maxMB = 10]) {
    final sizeInMB = lengthSync() / (1024 * 1024);

    return sizeInMB <= maxMB;
  }

  /// Generate a unique filename with timestamp and optional extension
  String setName(StoredIn type) {
    final extension = p.extension(path);
    final name = type.name.toUpperCase().toName;

    return '$name$extension';
  }
}
