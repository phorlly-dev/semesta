import 'package:jiffy/jiffy.dart';
import 'package:semesta/app/services/storage_service.dart';
import 'package:semesta/public/extensions/date_time_extension.dart';
import 'package:semesta/public/extensions/array_extension.dart';
import 'package:semesta/public/helpers/generic_helper.dart';
import 'package:semesta/public/helpers/params_helper.dart';
import 'package:semesta/public/utils/type_def.dart';

extension StringX on String {
  Jiffy get toDate => Jiffy.parse(this);
  bool get nil {
    if (isEmpty) {
      return true;
    } else if (this == '') {
      return true;
    } else {
      return false;
    }
  }

  /// Saving a file from a URL to local storage, with an optional callback for tracking download progress,
  /// used for downloading media files (like images or videos) from the internet and saving them to the device's local storage for offline access or further processing.
  AsWait toDownload(Defox<int, int, void>? onProgress) {
    return grepo.downloadFile(this, onProgress);
  }

  /// Formats a string as a unique name by appending the current timestamp, used for generating unique filenames
  /// or identifiers based on the original string and the current time to avoid naming conflicts.
  String get toName {
    return '${this}_${now.format('yyyyMMdd_HHmmssSSS')}';
  }

  int get toInt => int.parse(this);

  /// A helper method to convert a string into a file path for an asset, with an option to specify if it's an icon or an image,
  /// used for referencing asset files in the project by generating the correct path based on the type of asset.
  String toAsset([bool icon = false]) {
    return "assets/${icon ? 'icons' : images}/$this";
  }

  /// A helper method to limit the length of a string and append an ellipsis if it exceeds a specified number of characters,
  /// used for displaying shortened versions of long strings (like usernames or titles) in the UI while indicating that there is more text available.
  String limit([int maxChars = 24]) {
    if (length <= maxChars) return this;

    return '${substring(0, maxChars)}... ';
  }

  /// Url normalization, ensuring that the string starts with 'http' and providing a default scheme if it's missing,
  /// used for validating and standardizing URLs before using them in the application to ensure they are in a proper format.
  String get normalizeUrl {
    return startsWith('http') ? this : 'https://$this';
  }

  /// A helper method to check if a string can be navigated to as a profile, with an optional parameter for the currently viewed user ID,
  /// used for determining if a username or user ID in the string can be navigated to as a profile page, and optionally preventing navigation if it's the same as the currently viewed user.
  bool canNavigate([String? viewedUid]) {
    if (viewedUid == null) return true;
    return this != viewedUid;
  }

  /// A helper method to convert a string into a URL-friendly slug by replacing spaces with hyphens and converting to lowercase,
  /// used for generating slugs for URLs based on user input or titles to create SEO-friendly and readable URLs.
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
    final base = trim().replaceAll(' ', '_');
    final suffix = now.millisecondsSinceEpoch.toString().substring(10);

    return '$base$suffix';
  }

  /// Convert path to a file name by extracting the last segment after the last '/' character,
  /// used for generating a file name from a URL or file path for saving or referencing files in the application.
  String setPath(StoredIn type) {
    return switch (type) {
      StoredIn.video => '$videos/$this',
      StoredIn.cover => '$covers/$this',
      StoredIn.image => '$images/$this',
      StoredIn.avatar => '$avatars/$this',
      StoredIn.thumbnail => '$thumbnails/$this',
    };
  }

  /// A helper method to parse a string for hashtags and mentions,
  /// returning a ParsedText object containing lists of found hashtags and mentions,
  /// used for extracting hashtags and mentions from user input (like post captions or comments)
  /// for further processing (like linking or searching).
  ParsedText get parseText {
    final hashtags = hashtag.allMatches(this).map((m) => m.group(1)!).toArray;
    final mentions = mention.allMatches(this).map((m) => m.group(1)!).toArray;

    return ParsedText(hashtags, mentions);
  }

  /// A helper method to trigger a search for hashtags or mentions based on the cursor position in a text input,
  /// returning the matched trigger character (@ or #) if found, used for implementing autocomplete functionality
  /// for hashtags and mentions in text inputs by detecting when the user is typing a hashtag or mention and providing suggestions.
  String? trigger(int cursor) {
    if (cursor == 0) return null;

    final before = substring(0, cursor);
    final match = before.matchedFirst();
    if (match != null) {
      return match.group(2); // @ or #
    }

    return null;
  }

  /// A helper method to find the first match of a regular expression pattern in the string, used for extracting specific patterns (like hashtags or mentions) from the string based on a provided regex pattern.
  RegExpMatch? matchedFirst([String pattern = r'(^|\s)([@#])(\w*)$']) {
    return RegExp(pattern).firstMatch(this);
  }

  String replace([String pattern = r'@(\w*)$']) {
    final match = matchedFirst(pattern);
    if (match != null) return match.group(1)!;

    return this;
  }

  String normalize({String startAt = '@', String pattern = r'@(\w*)$'}) {
    return startsWith(startAt) ? replace(pattern) : '';
  }
}
