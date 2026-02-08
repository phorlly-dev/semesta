import 'package:semesta/public/helpers/generic_helper.dart';

DateTime syncDate([DateTime? date, bool isLocal = true]) {
  final effectiveDate = date ?? now;
  final local = effectiveDate.toLocal();
  final utc = effectiveDate.toUtc();

  return isLocal ? local : utc;
}

String toCount(int count) {
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
