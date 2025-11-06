import 'package:jiffy/jiffy.dart';

extension DateExtensions on DateTime {
  String get timeAgo => _formated(this).fromNow();
  String get timeTo => _formated(this).toNow();
  String get toTime => _formated(this).format(pattern: 'h:mm:ss a');
  String get toDate => _formated(this).format(pattern: 'do MMM yy');
  String get fullDateTime => _formated(this).yMMMMEEEEdjm;
  bool isBetween(DateTime from, DateTime to) {
    return _formated(this).isBetween(_formated(from), _formated(to));
  }

  String format(String style) => _formated(this).format(pattern: style);
  String from(DateTime past) => _formated(past).to(_formated(this));
  String to(DateTime past) => _formated(past).to(_formated(this));
  Jiffy _formated(DateTime date) => Jiffy.parseFromDateTime(date);
}

extension StringExtension on String {
  Jiffy get toDate => Jiffy.parse(this);
}
