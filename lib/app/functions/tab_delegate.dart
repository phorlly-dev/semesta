import 'package:flutter/material.dart';

class TabDelegate extends SliverPersistentHeaderDelegate {
  final TabBar _tabBar;
  TabDelegate(this._tabBar);

  @override
  double get minExtent => _tabBar.preferredSize.height;

  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) => Container(color: Colors.white, child: _tabBar);

  @override
  bool shouldRebuild(TabDelegate oldDelegate) => false;
}
