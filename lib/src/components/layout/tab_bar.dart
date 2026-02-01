import 'package:flutter/material.dart';

class AppTabBar extends StatelessWidget implements PreferredSizeWidget {
  final bool scrollable;
  final List<Widget> tabs;
  final ValueChanged<int>? onTap;
  final TabController? controller;
  final TabAlignment? tabAlignment;
  const AppTabBar({
    super.key,
    this.onTap,
    this.controller,
    this.tabAlignment,
    this.tabs = const [],
    this.scrollable = false,
  });

  @override
  Size get preferredSize => Size.fromHeight(kTextTabBarHeight);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: kTextTabBarHeight,
      child: TabBar(
        isScrollable: scrollable,
        controller: controller,
        indicatorSize: TabBarIndicatorSize.label,
        labelStyle: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
        unselectedLabelStyle: TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 14,
        ),
        tabAlignment: tabAlignment,
        tabs: tabs,
        onTap: onTap,
      ),
    );
  }
}
