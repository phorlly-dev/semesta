import 'package:flutter/material.dart';
import 'package:semesta/public/extensions/extension.dart';

class AppNavBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget? start, middle, end;
  final Color? color;
  final double? height;
  final bool centered;
  final PreferredSizeWidget? bottom;
  const AppNavBar({
    super.key,
    this.start,
    this.middle,
    this.end,
    this.bottom,
    this.color,
    this.height,
    this.centered = true,
  });

  @override
  Size get preferredSize => Size.fromHeight(height ?? 36);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: middle,
      leading: start,
      actions: [?end],
      bottom: bottom,
      elevation: 0,
      centerTitle: centered,
      scrolledUnderElevation: 0,
      surfaceTintColor: Colors.transparent,
      backgroundColor: color ?? context.defaultColor,
    );
  }
}
