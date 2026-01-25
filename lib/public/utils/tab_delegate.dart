import 'package:flutter/material.dart';
import 'package:semesta/src/components/layout/custom_tab_bar.dart';

class TabDelegate extends SliverPersistentHeaderDelegate {
  final CustomTabBar _tabBar;
  const TabDelegate(this._tabBar);

  @override
  double get minExtent => _tabBar.preferredSize.height;

  @override
  double get maxExtent => minExtent;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    final colors = Theme.of(context).scaffoldBackgroundColor;
    return Material(
      color: colors,
      elevation: shrinkOffset > 0 ? 2 : 0,
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(TabDelegate oldDelegate) => false;
}
