import 'package:flutter/material.dart';
import 'package:semesta/public/extensions/extension.dart';
import 'package:semesta/public/utils/scroll_aware_app_bar.dart';
import 'package:semesta/src/components/layout/tab_sliver.dart';
import 'package:semesta/src/components/layout/nav_bar_sliver.dart';
import 'package:semesta/src/components/layout/nested_scrollable.dart';
import 'package:semesta/src/components/layout/_page.dart';
import 'package:semesta/src/components/layout/_tab.dart';
import 'package:semesta/src/partials/user_followers_tab.dart';
import 'package:semesta/src/partials/user_following_tab.dart';

class UserFollowPage extends StatelessWidget {
  final String _uid, _name;
  final int index;
  const UserFollowPage(this._uid, this._name, {super.key, this.index = 0});

  @override
  Widget build(BuildContext context) {
    return PageLayout(
      content: TabLayout(
        index: index,
        tabs: ['Followers', 'Following'],
        builder: (ctrl, tab) => NestedScrollable(
          builder: (_) => [
            ScrollAwareAppBar(
              (visible) => AppNavBarSliver(
                middle: Text(_name),
                end: IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.person_add_alt_1_outlined),
                  color: context.outlineColor,
                ),
                toolbarHeight: visible ? kToolbarHeight : 0,
              ),
            ),

            TabSliver(tab),
          ],
          child: TabBarView(
            controller: ctrl,
            children: [UserFollowersTab(_uid), UserFollowingTab(_uid)],
          ),
        ),
      ),
    );
  }
}
