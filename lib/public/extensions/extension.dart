import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jiffy/jiffy.dart';
import 'package:provider/provider.dart';
import 'package:semesta/public/functions/option_modal.dart';
import 'package:semesta/public/functions/theme_manager.dart';
import 'package:semesta/public/functions/visible_option.dart';
import 'package:semesta/public/utils/params.dart';
import 'package:semesta/public/helpers/generic_helper.dart';
import 'package:semesta/public/utils/type_def.dart';

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

  String asImage([bool isIcon = false]) {
    return isIcon ? 'assets/icons/$this' : 'assets/images/$this';
  }

  String limitText([int maxChars = 24]) {
    if (length <= maxChars) return this;

    return '${substring(0, maxChars)}... ';
  }
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

extension GoRouterStateX on GoRouterState {
  String pathOrQuery(String key, [bool queried = false]) {
    String? params = pathParameters[key];

    if (queried) params = uri.queryParameters[key];
    if (params == null) {
      throw StateError('Invalid params key: $params');
    }

    return params;
  }
}

extension DateTimeX2 on DateTime? {
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
}

extension IntegerX on int {
  String get countable {
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

extension BuildContextX on BuildContext {
  Wait<void> openProfile(String uid, bool yourself) async {
    await pushNamed(
      route.profile.name,
      pathParameters: {'id': uid},
      queryParameters: {'yourself': yourself.toString()},
    );
  }

  Wait<void> openById(RouteNode route, String id) async {
    await pushNamed(route.name, pathParameters: {'id': id});
  }

  Wait<void> openFollow(
    RouteNode route,
    String id, {
    String name = '',
    int idx = 0,
  }) async {
    await pushNamed(
      route.name,
      pathParameters: {'id': id},
      queryParameters: {'name': name, 'index': idx.toString()},
    );
  }

  Wait<void> openPreview(RouteNode route, String id, [int idx = 0]) async {
    await pushNamed(
      route.name,
      pathParameters: {'id': id},
      queryParameters: {'index': idx.toString()},
    );
  }

  String get location => GoRouterState.of(this).matchedLocation;

  ThemeData get theme => Theme.of(this);
  TextTheme get text => theme.textTheme;
  ColorScheme get colors => theme.colorScheme;
  MediaQueryData get query => MediaQuery.of(this);

  OptionModal get open => OptionModal(this);
  VisibleOption get tap => VisibleOption(this);
  void get toggleTheme => read<ThemeManager>().toggleTheme(this);

  Color get hintColor => theme.hintColor;
  Color get errorColor => colors.error;
  Color get primaryColor => colors.primary;
  Color get outlineColor => colors.outline;
  Color get secondaryColor => colors.secondary;
  Color get defaultColor => theme.scaffoldBackgroundColor;
  Color get dividerColor => theme.dividerColor.withValues(alpha: 0.5);
  Color? get navigatColor => theme.bottomNavigationBarTheme.backgroundColor;

  double get width => MediaQuery.of(this).size.width;
  double get height => MediaQuery.of(this).size.height;
}
