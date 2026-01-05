import 'package:jiffy/jiffy.dart';

extension DateTimeX on DateTime {
  String get timeAgo => _formated(this).fromNow();
  String get timeTo => _formated(this).toNow();
  String get toTime => _formated(this).format(pattern: 'h:mm:ss a');
  String get toDate => _formated(this).format(pattern: 'do MMM yyyy');
  String get fullDateTime => _formated(this).yMMMMEEEEdjm;
  bool isBetween(DateTime from, DateTime to) {
    return _formated(this).isBetween(_formated(from), _formated(to));
  }

  String format(String style) => _formated(this).format(pattern: style);
  String from(DateTime past) => _formated(past).to(_formated(this));
  String to(DateTime past) => _formated(past).to(_formated(this));
  Jiffy _formated(DateTime date) => Jiffy.parseFromDateTime(date);
}

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

  int get toInt => int.parse(this);
}

extension StringX2 on String? {
  bool get isNull {
    if (this == null) {
      return true;
    } else if (this == '') {
      return true;
    } else {
      return false;
    }
  }
}
