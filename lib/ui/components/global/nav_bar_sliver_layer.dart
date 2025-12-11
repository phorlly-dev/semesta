import 'package:flutter/material.dart';

class NavBarSliverLayer extends StatelessWidget {
  final Widget? start, middle, flexible;
  final List<Widget>? ends;
  final bool pinned, isForce;
  final double? expandedHeight;
  final PreferredSizeWidget? bottom;
  final Color? bgColor;

  const NavBarSliverLayer({
    super.key,
    this.start,
    this.middle,
    this.ends,
    this.bottom,
    this.pinned = false,
    this.flexible,
    this.expandedHeight,
    this.bgColor,
    this.isForce = false,
  });

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      centerTitle: true,
      pinned: pinned,
      leading: start,
      title: middle,
      bottom: bottom,
      actions: ends,
      forceElevated: isForce,
      backgroundColor: bgColor,
      expandedHeight: expandedHeight,
      flexibleSpace: flexible,
    );
  }
}
