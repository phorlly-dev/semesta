import 'package:flutter/material.dart';
import 'package:semesta/public/utils/type_def.dart';
import 'package:semesta/src/components/layout/tab_bar.dart';

class TabLayout extends StatefulWidget {
  final int index;
  final AsList tabs;
  final bool scrollable;
  final ValueChanged<int>? onTap;
  final TabAlignment? tabAlignment;
  final Defox<TabController, AppTabBar, Widget> builder;
  const TabLayout({
    super.key,
    this.index = 0,
    this.onTap,
    this.tabAlignment,
    this.tabs = const [],
    required this.builder,
    this.scrollable = false,
  });

  @override
  State<TabLayout> createState() => _TabLayoutState();
}

class _TabLayoutState extends State<TabLayout>
    with SingleTickerProviderStateMixin {
  late TabController _ctrl;

  AsList get _tabs => widget.tabs;
  AppTabBar get _tabBar => AppTabBar(
    controller: _ctrl,
    scrollable: widget.scrollable,
    tabAlignment: widget.tabAlignment,
    tabs: _tabs.map((e) => Tab(text: e)).toList(),
    onTap: widget.onTap,
  );

  @override
  void initState() {
    _ctrl = TabController(
      vsync: this,
      length: _tabs.length,
      initialIndex: widget.index,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) => widget.builder.call(_ctrl, _tabBar);

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }
}
