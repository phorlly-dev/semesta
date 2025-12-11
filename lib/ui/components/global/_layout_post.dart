import 'package:flutter/material.dart';
import 'package:semesta/app/utils/type_def.dart';
import 'package:semesta/ui/components/global/content_sliver_layer.dart';
import 'package:semesta/ui/components/global/nav_bar_sliver_layer.dart';
import 'package:semesta/ui/widgets/avatar_animation.dart';
import 'package:semesta/ui/widgets/custom_tab_bar.dart';

class PostLayout extends StatefulWidget {
  final bool isVisible;
  final String avatar;
  final ScrollController scroller;
  final PropsCallback<int, void>? onTap;
  final VoidCallback? onLogo;
  final List<Widget> children;

  const PostLayout({
    super.key,
    this.isVisible = false,
    required this.scroller,
    required this.avatar,
    this.onTap,
    required this.children,
    this.onLogo,
  });

  @override
  State<PostLayout> createState() => _PostLayoutState();
}

class _PostLayoutState extends State<PostLayout>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return ContentSliverLayer(
      scroller: widget.scroller,
      builder: (boxInScrolled) {
        return [
          if (widget.isVisible)
            NavBarSliverLayer(
              isForce: boxInScrolled,
              start: Padding(
                padding: const EdgeInsets.all(8.0),
                child: AvatarAnimation(
                  imageUrl: widget.avatar,
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
              bottom: CustomTabBar(
                controller: _tabController,
                tabs: [
                  Tab(text: 'For You'),
                  Tab(text: 'Following'),
                ],
                onTap: widget.onTap,
              ),
              ends: [
                Container(
                  margin: EdgeInsets.only(right: 12),
                  child: IconButton(
                    color: colors.outline,
                    onPressed: () {},
                    icon: Icon(Icons.search, size: 26),
                  ),
                ),
              ],
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
