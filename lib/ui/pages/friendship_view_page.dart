import 'package:flutter/material.dart';
import 'package:semesta/ui/components/layouts/_layout_page.dart';
import 'package:semesta/ui/components/users/friendship_view.dart';
import 'package:semesta/ui/partials/followers_tab.dart';
import 'package:semesta/ui/partials/following_tab.dart';

class FriendshipViewPage extends StatelessWidget {
  final String uid, displayName;
  final int index;
  const FriendshipViewPage({
    super.key,
    required this.uid,
    required this.displayName,
    this.index = 0,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutPage(
      content: FriendshipView(
        name: displayName,
        initIndex: index,
        children: [
          FollowersTab(uid: uid),
          FollowingTab(uid: uid),
        ],
      ),
    );
  }
}
