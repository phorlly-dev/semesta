import 'package:flutter/material.dart';
import 'package:semesta/public/extensions/extension.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget? start, middle, end;
  final Color? color;
  final double? height;
  final PreferredSizeWidget? bottom;
  const CustomAppBar({
    super.key,
    this.start,
    this.middle,
    this.end,
    this.bottom,
    this.color,
    this.height,
  });

  @override
  Size get preferredSize => Size.fromHeight(height ?? 36);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      title: middle,
      leading: start,
      actions: [?end],
      bottom: bottom,
      elevation: 0,
      backgroundColor: color ?? context.defaultColor,
      scrolledUnderElevation: 0,
      surfaceTintColor: Colors.transparent,
    );
  }
}
