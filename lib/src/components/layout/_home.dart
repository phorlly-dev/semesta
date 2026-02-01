import 'package:flutter/material.dart';
import 'package:semesta/public/extensions/extension.dart';
import 'package:semesta/public/utils/params.dart';
import 'package:semesta/src/components/layout/_page.dart';
import 'package:semesta/src/components/layout/nav_bar.dart';
import 'package:semesta/src/components/layout/_tab.dart';
import 'package:semesta/src/widgets/sub/animated_avatar.dart';

class HomeLayout extends StatelessWidget {
  final bool visible;
  final String _avatar;
  final ValueChanged<int>? onTap;
  final VoidCallback? onLogo;
  final List<Widget> children;
  const HomeLayout(
    this._avatar, {
    super.key,
    this.onTap,
    this.onLogo,
    this.visible = true,
    this.children = const [],
  });

  @override
  Widget build(BuildContext context) {
    return TabLayout(
      tabs: ['For You', 'Following'],
      onTap: onTap,
      builder: (ctrl, tab) => PageLayout(
        header: visible
            ? AppNavBar(
                height: 92,
                start: AvatarAnimation(
                  MediaSource.network(_avatar),
                  size: 32,
                  padding: const EdgeInsets.all(4.0),
                  onTap: () => Scaffold.of(context).openDrawer(),
                ),
                middle: GestureDetector(
                  onTap: onLogo,
                  child: Text(
                    'Semesta',
                    style: TextStyle(
                      color: context.colors.primary,
                      fontWeight: FontWeight.w700,
                      fontSize: 20,
                    ),
                  ),
                ),
                end: IconButton(
                  color: context.colors.outline,
                  onPressed: () {},
                  icon: Icon(Icons.search, size: 26),
                ),
                bottom: tab,
              )
            : null,
        content: TabBarView(controller: ctrl, children: children),
      ),
    );
  }
}
