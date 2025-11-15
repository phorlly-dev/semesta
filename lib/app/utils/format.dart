import 'package:get/get.dart';

String setImage(String path, [bool isIcon = false]) =>
    isIcon ? 'assets/icons/$path' : 'assets/images/$path';

DateTime syncDate([DateTime? date, bool isLocal = true]) {
  final effectiveDate = date ?? DateTime.now();
  final local = effectiveDate.toLocal();
  final utc = effectiveDate.toUtc();

  return isLocal ? local : utc;
}

String timeAgo(DateTime date) {
  final now = DateTime.now();
  final diff = now.difference(date);

  if (diff.inSeconds < 60) return '${diff.inSeconds}s';
  if (diff.inMinutes < 60) return '${diff.inMinutes}m';
  if (diff.inHours <= 23) return '${diff.inHours}h';
  if (diff.inHours <= 24) return 'Today';
  if (diff.inDays == 1) return 'Yesterday';
  if (diff.inDays < 7) return '${diff.inDays}d';
  if (diff.inDays < 30) return '${(diff.inDays / 7).floor()}w';
  if (diff.inDays < 365) return '${(diff.inDays / 30).floor()}mo';

  return '${(diff.inDays / 365).floor()}y';
}

String toCapitalize(String? name) => name?.capitalize ?? '';
