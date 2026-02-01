import 'package:flutter/material.dart';
import 'package:semesta/public/extensions/extension.dart';
import 'package:semesta/public/utils/delegate.dart';
import 'package:semesta/src/components/layout/tab_bar.dart';

class TabSliver extends StatelessWidget {
  final AppTabBar _tabBar;
  final bool pinned, floating;
  const TabSliver(
    this._tabBar, {
    super.key,
    this.pinned = true,
    this.floating = false,
  });

  @override
  Widget build(BuildContext context) {
    return SliverPersistentHeader(
      pinned: pinned,
      floating: floating,
      delegate: Delegate(
        builder: (min, max, shrink) => Material(
          color: context.defaultColor,
          elevation: shrink > 0 ? 2 : 0,
          child: _tabBar,
        ),
        min: _tabBar.preferredSize.height,
        max: _tabBar.preferredSize.height,
      ),
    );
  }
}
