import 'package:flutter/material.dart';
import 'package:semesta/app/utils/type_def.dart';

class CustomTabBar extends StatelessWidget implements PreferredSizeWidget {
  final TabController controller;
  final List<Widget> tabs;
  final PropsCallback<int, void>? onTap;
  final bool isScrollable;
  final TabAlignment? tabAlignment;
  const CustomTabBar({
    super.key,
    required this.controller,
    required this.tabs,
    this.onTap,
    this.isScrollable = false,
    this.tabAlignment,
  });

  @override
  Size get preferredSize => Size.fromHeight(kTextTabBarHeight);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: kTextTabBarHeight,
      child: TabBar(
        isScrollable: isScrollable,
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
