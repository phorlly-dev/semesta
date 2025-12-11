import 'package:flutter/material.dart';
import 'package:semesta/ui/widgets/custom_tab_bar.dart';

class TabDelegate extends SliverPersistentHeaderDelegate {
  final CustomTabBar _tabBar;
  TabDelegate(this._tabBar);

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
    final colors = Theme.of(context).colorScheme;

    return Material(
      color: colors.surface,
      elevation: shrinkOffset > 0 ? 2 : 0,
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(TabDelegate oldDelegate) => false;
}
