import 'package:flutter/material.dart';
import 'package:semesta/ui/components/users/account_profile.dart';
import 'package:semesta/ui/partials/likes_tab.dart';
import 'package:semesta/ui/partials/media_tab.dart';
import 'package:semesta/ui/partials/posts_tab.dart';
import 'package:semesta/ui/components/global/_layout_page.dart';
import 'package:semesta/ui/partials/replies_tab.dart';
import 'package:semesta/ui/partials/reposts_tab.dart';

class ProfileViewPage extends StatelessWidget {
  final String userId;
  final bool isOwner;
  const ProfileViewPage({
    super.key,
    required this.userId,
    required this.isOwner,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutPage(
      content: AccountProfile(
        userId: userId,
        isOwner: isOwner,
        children: [
          PostsTab(userId: userId),
          RepliesTab(userId: userId),
          MediaTab(userId: userId),
          RepostsTab(userId: userId),
          if (isOwner) LikesTab(userId: userId),
        ],
      ),
    );
  }
}
