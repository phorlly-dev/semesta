import 'package:flutter/material.dart';
import 'package:semesta/app/functions/tab_delegate.dart';
import 'package:semesta/app/utils/type_def.dart';
import 'package:semesta/ui/components/global/content_sliver_layer.dart';
import 'package:semesta/ui/components/global/nav_bar_sliver_layer.dart';
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
    return ContentSliverLayer(
      builder: (boxInScrolled) {
        return [
          NavBarSliverLayer(
            isForce: boxInScrolled,
            middle: Text(widget.name),
            ends: [
              IconButton(
                onPressed: () {},
                icon: Icon(Icons.person_add_alt_1_outlined),
                color: colors.outline,
              ),
            ],
          ),

          // Tab bar section
          SliverPersistentHeader(
            pinned: true,
            delegate: TabDelegate(
              CustomTabBar(
                controller: _tabController,
                tabs: tabs.map((tab) => Tab(text: tab)).toList(),
                onTap: widget.onTap,
              ),
            ),
          ),
        ];
      },
      content: TabBarView(
        controller: _tabController,
        children: widget.children,
      ),
    );
  }
}
