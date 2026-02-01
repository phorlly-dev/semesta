import 'package:flutter/material.dart';
import 'package:semesta/public/helpers/generic_helper.dart';
import 'package:semesta/public/mixins/repo_mixin.dart';
import 'package:semesta/src/components/user/follow_tile.dart';
import 'package:semesta/src/components/global/cached_tab.dart';

class UserFollowersTab extends StatelessWidget {
  final String _uid;
  const UserFollowersTab(this._uid, {super.key});

  @override
  Widget build(BuildContext context) {
    return CachedTab(
      controller: uctrl,
      cache: uctrl.stateFor('follow:$_uid:followers'),
      message: "There's no followers yet.",
      onInit: () => uctrl.loadUserFollowers(_uid),
      onMore: () => uctrl.loadUserFollowers(_uid, QueryMode.next),
      onRefresh: () => uctrl.loadUserFollowers(_uid, QueryMode.refresh),
      builder: (item) => FollowTile(item.currentId),
    );
  }
}
