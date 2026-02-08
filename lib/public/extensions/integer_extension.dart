extension IntegerX on int {
  String get format {
    String formatted;
    if (this >= 1000000000) {
      formatted = (this / 1000000000).toStringAsFixed(1);
      return formatted.endsWith('.0')
          ? '${formatted.split('.').first}B'
          : '${formatted}B';
    } else if (this >= 1000000) {
      formatted = (this / 1000000).toStringAsFixed(1);
      return formatted.endsWith('.0')
          ? '${formatted.split('.').first}M'
          : '${formatted}M';
    } else if (this >= 1000) {
      formatted = (this / 1000).toStringAsFixed(1);
      return formatted.endsWith('.0')
          ? '${formatted.split('.').first}K'
          : '${formatted}K';
    } else {
      return toString();
    }
  }
}
