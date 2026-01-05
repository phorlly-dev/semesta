import 'package:flutter/material.dart';
import 'package:semesta/app/utils/tab_delegate.dart';
import 'package:semesta/app/utils/type_def.dart';
import 'package:semesta/ui/widgets/custom_tab_bar.dart';

class ListFriendship extends StatefulWidget {
  final List<Widget> children;
  final String name;
  final PropsCallback<int, void>? onTap;
  final int initIndex;
  const ListFriendship({
    super.key,
    required this.children,
    required this.name,
    this.onTap,
    this.initIndex = 0,
  });

  @override
  State<ListFriendship> createState() => _ListFriendshipState();
}

class _ListFriendshipState extends State<ListFriendship>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<String> get tabs => ['Followers', 'Following'];
  CustomTabBar get tabBar => CustomTabBar(
    controller: _tabController,
    tabs: tabs.map((tab) => Tab(text: tab)).toList(),
    onTap: widget.onTap,
  );

  @override
  void initState() {
    _tabController = TabController(
      length: tabs.length,
      vsync: this,
      initialIndex: widget.initIndex,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return NestedScrollView(
      headerSliverBuilder: (_, innerBox) => [
        SliverAppBar(
          centerTitle: true,
          title: Text(widget.name),
          actions: [
            IconButton(
              onPressed: () {},
              icon: Icon(Icons.person_add_alt_1_outlined),
              color: colors.outline,
            ),
          ],
        ),

        SliverPersistentHeader(
          pinned: true,
          floating: true,
          delegate: TabDelegate(tabBar),
        ),
      ],
      body: TabBarView(controller: _tabController, children: widget.children),
    );
  }
}
