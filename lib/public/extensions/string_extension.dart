import 'package:jiffy/jiffy.dart';
import 'package:semesta/app/services/storage_service.dart';
import 'package:semesta/public/extensions/date_time_extension.dart';
import 'package:semesta/public/helpers/generic_helper.dart';
import 'package:semesta/public/utils/type_def.dart';

extension StringX on String {
  Jiffy get toDate => Jiffy.parse(this);
  bool get isNull {
    if (isEmpty) {
      return true;
    } else if (this == '') {
      return true;
    } else {
      return false;
    }
  }

  AsWait toDownload(void Function(int received, int total)? onProgress) {
    return grepo.downloadFile(this, onProgress);
  }

  String get toName {
    return '${this}_${now.format('yyyyMMdd_HHmmssSSS')}';
  }

  int get toInt => int.parse(this);

  String toIcon([bool isIcon = false]) {
    return "assets/${isIcon ? 'icons' : 'images'}/$this";
  }

  String limitText([int maxChars = 24]) {
    if (length <= maxChars) return this;

    return '${substring(0, maxChars)}... ';
  }

  String get normalizeUrl {
    if (!startsWith('http')) return 'https://$this';

    return this;
  }

  bool canNavigate([String? viewedUid]) {
    if (viewedUid == null) return true;
    return this != viewedUid;
  }

  String get toUrl {
    try {
      final uri = Uri.parse(this);

      final host = uri.host.replaceFirst('www.', '');
      final path = uri.path;

      if (path.isEmpty) return host;

      // show only first segment
      final segments = uri.pathSegments;
      if (segments.isEmpty) return host;

      return '$host/${segments.first}…';
    } catch (_) {
      return this;
    }
  }

  // Normalize: remove spaces/special chars
  String get toUsername {
    final base = trim().replaceAll(RegExp(r'[^a-z0-9]'), '_');
    final suffix = now.millisecondsSinceEpoch.toString().substring(10);

    return '$base$suffix';
  }

  String setPath(StoredIn type) {
    return switch (type) {
      StoredIn.video => '$videos/$this',
      StoredIn.cover => '$covers/$this',
      StoredIn.image => '$images/$this',
      StoredIn.avatar => '$avatars/$this',
      StoredIn.thumbnail => '$thumbnails/$this',
    };
  }
}
