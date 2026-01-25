import 'package:flutter/material.dart';
import 'package:semesta/src/components/layout/_layout_page.dart';
import 'package:semesta/src/partials/user_follow.dart';
import 'package:semesta/src/partials/followers_tab.dart';
import 'package:semesta/src/partials/following_tab.dart';

class UserFollowPage extends StatelessWidget {
  final String uid, name;
  final int index;
  const UserFollowPage({
    super.key,
    required this.uid,
    required this.name,
    this.index = 0,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutPage(
      content: UserFollow(
        name,
        initIndex: index,
        children: [FollowersTab(uid), FollowingTab(uid)],
      ),
    );
  }
}
