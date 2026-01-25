import 'package:flutter/material.dart';
import 'package:semesta/public/utils/type_def.dart';
import 'package:semesta/src/components/layout/_layout_page.dart';
import 'package:semesta/src/components/layout/custom_app_bar.dart';
import 'package:semesta/src/components/layout/custom_tab_bar.dart';
import 'package:semesta/src/widgets/sub/avatar_animation.dart';

class HomeLayout extends StatefulWidget {
  final bool isVisible;
  final String avatar;
  final ValueChanged<int>? onTap;
  final VoidCallback? onLogo;
  final List<Widget> children;
  const HomeLayout({
    super.key,
    this.isVisible = true,
    required this.avatar,
    this.onTap,
    required this.children,
    this.onLogo,
  });

  @override
  State<HomeLayout> createState() => _HomeLayoutState();
}

class _HomeLayoutState extends State<HomeLayout>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  AsList get tabs => ['For You', 'Following'];
  CustomTabBar get tabBar => CustomTabBar(
    controller: _tabController,
    tabs: tabs.map((e) => Tab(text: e)).toList(),
    onTap: widget.onTap,
  );

  @override
  void initState() {
    _tabController = TabController(length: tabs.length, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return LayoutPage(
      header: widget.isVisible
          ? CustomAppBar(
              height: 92,
              start: Padding(
                padding: const EdgeInsets.all(4.0),
                child: AvatarAnimation(
                  widget.avatar,
                  size: 32,
                  onTap: () => Scaffold.of(context).openDrawer(),
                ),
              ),
              middle: GestureDetector(
                onTap: widget.onLogo,
                child: Text(
                  'Semesta',
                  style: TextStyle(
                    color: colors.primary,
                    fontWeight: FontWeight.w700,
                    fontSize: 20,
                  ),
                ),
              ),
              end: IconButton(
                color: colors.outline,
                onPressed: () {},
                icon: Icon(Icons.search, size: 26),
              ),
              bottom: tabBar,
            )
          : null,
      content: TabBarView(
        controller: _tabController,
        children: widget.children,
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}
