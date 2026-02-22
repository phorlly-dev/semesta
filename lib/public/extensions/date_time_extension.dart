import 'package:jiffy/jiffy.dart';
import 'package:semesta/public/helpers/generic_helper.dart';

extension DateTimeX on DateTime {
  String get timeAgo => _formated(this).fromNow();
  String get timeTo => _formated(this).toNow();
  String get toTime => _formated(this).format(pattern: 'h:mm:ss a');
  String get toDate => _formated(this).format(pattern: 'dd MMMM yyyy');
  String get fullDateTime => _formated(this).yMMMMEEEEdjm;
  bool isBetween(DateTime from, DateTime to) {
    return _formated(this).isBetween(_formated(from), _formated(to));
  }

  String get todayKey => toIso8601String().split('T')[0];

  String format(String style) => _formated(this).format(pattern: style);
  String from(DateTime past) => _formated(past).to(_formated(this));
  String to(DateTime past) => _formated(past).to(_formated(this));
  Jiffy _formated(DateTime date) => Jiffy.parseFromDateTime(date);
}

extension DateTimeX2 on DateTime? {
  /// A helper method to convert a nullable DateTime into a human-readable "time ago" format,
  /// used for displaying how long ago an event occurred.
  String get toAgo {
    if (this == null) return '';

    final diff = now.difference(this!);

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

  /// A helper method to calculate age from a DateTime, used for displaying a user's age based on their birthdate.
  int get toAge {
    final val = this;
    if (val == null) return 0;

    final ym = now.year - val.year;
    final ml = now.month < val.month;
    final me = now.month == val.month;
    final dl = now.day < val.day;

    return ym - ((ml || (me && dl)) ? 1 : 0);
  }
}
