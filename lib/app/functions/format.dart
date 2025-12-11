import 'package:get/get.dart';

String setImage(String path, [bool isIcon = false]) =>
    isIcon ? 'assets/icons/$path' : 'assets/images/$path';

DateTime syncDate([DateTime? date, bool isLocal = true]) {
  final effectiveDate = date ?? DateTime.now();
  final local = effectiveDate.toLocal();
  final utc = effectiveDate.toUtc();

  return isLocal ? local : utc;
}

String timeAgo(DateTime? date) {
  if (date == null) return '';

  final now = DateTime.now();
  final diff = now.difference(date);

  if (diff.inSeconds < 60) return 'Just now';
  if (diff.inMinutes < 60) return '${diff.inMinutes}m';
  if (diff.inHours < 24) return '${diff.inHours}h';
  if (diff.inDays == 0) return 'Today';
  if (diff.inDays == 1) return 'Yesterday';
  if (diff.inDays < 7) return '${diff.inDays}d';
  if (diff.inDays < 30) return '${(diff.inDays / 7).floor()}w';
  if (diff.inDays < 365) return '${(diff.inDays / 30).floor()}mo';

  return '${(diff.inDays / 365).floor()}y';
}

String toCapitalize(String? name) => name?.capitalize ?? '';

String formatCount(int count) {
  String formatted;
  if (count >= 1000000000) {
    formatted = (count / 1000000000).toStringAsFixed(1);
    return formatted.endsWith('.0')
        ? '${formatted.split('.').first}B'
        : '${formatted}B';
  } else if (count >= 1000000) {
    formatted = (count / 1000000).toStringAsFixed(1);
    return formatted.endsWith('.0')
        ? '${formatted.split('.').first}M'
        : '${formatted}M';
  } else if (count >= 1000) {
    formatted = (count / 1000).toStringAsFixed(1);
    return formatted.endsWith('.0')
        ? '${formatted.split('.').first}K'
        : '${formatted}K';
  } else {
    return count.toString();
  }
}

String limitText(String text, [int maxChars = 12]) {
  if (text.length <= maxChars) return text;

  return '${text.substring(0, maxChars)}... ';
}

bool isNot(dynamic data) {
  if (data == null) {
    return true;
  } else if (data.isEmpty ?? false) {
    return true;
  } else if (data == '') {
    return true;
  } else {
    return false;
  }
}

List<String> hashOrAt(String text) {
  final texts = <String>[];
  final regex = RegExp(r'(@\w+|#\w+)');
  int start = 0;

  for (final match in regex.allMatches(text)) {
    if (match.start > start) {
      texts.add(text.substring(start, match.start));
    }

    final word = match.group(0)!;
    texts.add(word);
    start = match.end;
  }

  if (start < text.length) {
    texts.add(text.substring(start));
  }

  return texts;
}
