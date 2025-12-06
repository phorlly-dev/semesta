import 'package:flutter/material.dart';

class HeaderSliverLayer extends StatelessWidget {
  final Widget? start, middle, flexible;
  final List<Widget>? ends;
  final bool pinned;
  final double? expandedHeight;
  final PreferredSizeWidget? bottom;
  final Color? bgColor;

  const HeaderSliverLayer({
    super.key,
    this.start,
    this.middle,
    this.ends,
    this.bottom,
    this.pinned = false,
    this.flexible,
    this.expandedHeight,
    this.bgColor,
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
      backgroundColor: bgColor,
      expandedHeight: expandedHeight,
      flexibleSpace: flexible,
    );
  }
}
