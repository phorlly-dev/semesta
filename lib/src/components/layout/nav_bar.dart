import 'package:flutter/material.dart';
import 'package:semesta/public/extensions/context_extension.dart';

class AppNavBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget? start, middle, end;
  final Color? color;
  final double? height;
  final bool centered;
  final PreferredSizeWidget? bottom;
  final Widget? flexible;
  const AppNavBar({
    super.key,
    this.start,
    this.middle,
    this.end,
    this.bottom,
    this.color,
    this.height,
    this.centered = true,
    this.flexible,
  });

  @override
  Size get preferredSize => Size.fromHeight(height ?? kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: middle,
      leading: start,
      actions: [?end],
      bottom: bottom,
      elevation: 0,
      centerTitle: centered,
      flexibleSpace: flexible,
      scrolledUnderElevation: 0,
      animateColor: true,
      actionsPadding: EdgeInsets.only(right: 6),
      surfaceTintColor: Colors.transparent,
      backgroundColor: color ?? context.defaultColor,
    );
  }
}
