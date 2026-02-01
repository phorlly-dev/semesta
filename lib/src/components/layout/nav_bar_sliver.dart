import 'package:flutter/material.dart';
import 'package:semesta/public/extensions/extension.dart';

class AppNavBarSliver extends StatelessWidget implements PreferredSizeWidget {
  final double toolbarHeight;
  final double? expandedHeight;
  final bool snap, floating, pinned, centered;
  final Widget? start, middle, end, flexible;
  final PreferredSizeWidget? bottom;
  final Color? backgroundColor;
  const AppNavBarSliver({
    super.key,
    this.toolbarHeight = kToolbarHeight,
    this.snap = true,
    this.floating = true,
    this.centered = true,
    this.pinned = false,
    this.start,
    this.middle,
    this.end,
    this.flexible,
    this.bottom,
    this.expandedHeight,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      leading: start,
      title: middle,
      actions: [?end],
      snap: snap,
      pinned: pinned,
      floating: floating,
      centerTitle: centered,
      flexibleSpace: flexible,
      elevation: 0,
      bottom: bottom,
      expandedHeight: expandedHeight,
      scrolledUnderElevation: 0,
      toolbarHeight: toolbarHeight,
      backgroundColor: backgroundColor ?? context.defaultColor,
      surfaceTintColor: Colors.transparent,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(expandedHeight ?? kToolbarHeight);
}
