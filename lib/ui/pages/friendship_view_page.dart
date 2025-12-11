import 'package:flutter/material.dart';
import 'package:semesta/ui/components/global/_layout_page.dart';
import 'package:semesta/ui/components/users/list_friendship.dart';
import 'package:semesta/ui/partials/followers_tab.dart';
import 'package:semesta/ui/partials/following_tab.dart';

class FriendshipViewPage extends StatelessWidget {
  final String userId, displayName;
  final int index;
  const FriendshipViewPage({
    super.key,
    required this.userId,
    required this.displayName,
    this.index = 0,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutPage(
      content: ListFriendship(
        name: displayName,
        initIndex: index,
        children: [
          FollowersTab(userId: userId),
          FollowingTab(userId: userId),
        ],
      ),
    );
  }
}
