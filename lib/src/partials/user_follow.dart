import 'package:flutter/material.dart';
import 'package:semesta/public/extensions/extension.dart';
import 'package:semesta/public/utils/scroll_aware_app_bar.dart';
import 'package:semesta/public/utils/tab_delegate.dart';
import 'package:semesta/public/utils/type_def.dart';
import 'package:semesta/src/components/layout/custom_tab_bar.dart';

class UserFollow extends StatefulWidget {
  final String _name;
  final int initIndex;
  final List<Widget> children;
  final ValueChanged<int>? onTap;
  const UserFollow(
    this._name, {
    super.key,
    this.onTap,
    this.initIndex = 0,
    this.children = const [],
  });

  @override
  State<UserFollow> createState() => _UserFollowState();
}

class _UserFollowState extends State<UserFollow>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  AsList get _tabs => ['Followers', 'Following'];
  CustomTabBar get _tabBar => CustomTabBar(
    controller: _tabController,
    tabs: _tabs.map((tab) => Tab(text: tab)).toList(),
    onTap: widget.onTap,
  );

  @override
  void initState() {
    _tabController = TabController(
      vsync: this,
      length: _tabs.length,
      initialIndex: widget.initIndex,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return NestedScrollView(
      headerSliverBuilder: (_, innerBox) => [
        ScrollAwareAppBar(
          (visible) => SliverAppBar(
            centerTitle: true,
            floating: true,
            snap: true,
            title: Text(widget._name),
            actions: [
              IconButton(
                onPressed: () {},
                icon: Icon(Icons.person_add_alt_1_outlined),
                color: context.outlineColor,
              ),
            ],
            elevation: 0,
            scrolledUnderElevation: 0,
            toolbarHeight: visible ? kToolbarHeight : 0,
            backgroundColor: context.defaultColor,
            surfaceTintColor: Colors.transparent,
          ),
        ),

        SliverPersistentHeader(pinned: true, delegate: TabDelegate(_tabBar)),
      ],
      body: TabBarView(controller: _tabController, children: widget.children),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}
