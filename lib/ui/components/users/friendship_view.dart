import 'package:flutter/material.dart';
import 'package:semesta/app/utils/scroll_aware_app_bar.dart';
import 'package:semesta/app/utils/tab_delegate.dart';
import 'package:semesta/ui/components/layouts/custom_tab_bar.dart';

class FriendshipView extends StatefulWidget {
  final String name;
  final int initIndex;
  final List<Widget> children;
  final ValueChanged<int>? onTap;
  const FriendshipView({
    super.key,
    this.onTap,
    this.initIndex = 0,
    required this.name,
    required this.children,
  });

  @override
  State<FriendshipView> createState() => _FriendshipViewState();
}

class _FriendshipViewState extends State<FriendshipView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  List<String> get _tabs => ['Followers', 'Following'];
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
    final colors = Theme.of(context).colorScheme;
    return NestedScrollView(
      headerSliverBuilder: (_, innerBox) => [
        ScrollAwareAppBar(
          builder: (visible) => SliverAppBar(
            centerTitle: true,
            floating: true,
            snap: true,
            title: Text(widget.name),
            actions: [
              IconButton(
                onPressed: () {},
                icon: Icon(Icons.person_add_alt_1_outlined),
                color: colors.outline,
              ),
            ],
            toolbarHeight: visible ? kToolbarHeight : 0,
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
