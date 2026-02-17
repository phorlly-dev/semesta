import 'package:flutter/material.dart';
import 'package:semesta/public/extensions/context_extension.dart';

class AppNavBarSliver extends StatelessWidget implements PreferredSizeWidget {
  final double toolbar;
  final double? expanded;
  final bool snap, floating, pinned, centered;
  final Widget? start, middle, end, flexible;
  final PreferredSizeWidget? bottom;
  final Color? background;
  const AppNavBarSliver({
    super.key,
    this.toolbar = kToolbarHeight,
    this.snap = true,
    this.floating = true,
    this.centered = true,
    this.pinned = false,
    this.start,
    this.middle,
    this.end,
    this.flexible,
    this.bottom,
    this.expanded,
    this.background,
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
      expandedHeight: expanded,
      scrolledUnderElevation: 0,
      toolbarHeight: toolbar,
      surfaceTintColor: Colors.transparent,
      actionsPadding: EdgeInsets.only(right: 6),
      backgroundColor: background ?? context.defaultColor,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(expanded ?? kToolbarHeight);
}
