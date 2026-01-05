import 'package:flutter/material.dart';

class NavBarLayer extends StatelessWidget implements PreferredSizeWidget {
  final Widget? start, middle, end;
  final Color? bgColor;
  final double? height;
  final PreferredSizeWidget? bottom;
  const NavBarLayer({
    super.key,
    this.start,
    this.middle,
    this.end,
    this.bottom,
    this.bgColor,
    this.height,
  });

  @override
  Size get preferredSize =>
      Size.fromHeight(height ?? kBottomNavigationBarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      title: middle,
      leading: start,
      actions: [?end],
      bottom: bottom,
      backgroundColor: bgColor,
    );
  }
}
