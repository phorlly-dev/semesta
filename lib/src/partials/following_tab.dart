import 'package:flutter/material.dart';
import 'package:semesta/public/helpers/generic_helper.dart';
import 'package:semesta/public/mixins/repo_mixin.dart';
import 'package:semesta/src/components/user/follow_tile.dart';
import 'package:semesta/src/components/global/cached_tab.dart';

class FollowingTab extends StatelessWidget {
  final String _uid;
  const FollowingTab(this._uid, {super.key});

  @override
  Widget build(BuildContext context) {
    return CachedTab(
      controller: uctrl,
      cache: uctrl.stateFor('follow:$_uid:following'),
      emptyMessage: "There's no followings yet.",
      onInitial: () => uctrl.loadUserFollowing(_uid),
      onMore: () => uctrl.loadUserFollowing(_uid, QueryMode.next),
      onRefresh: () => uctrl.loadUserFollowing(_uid, QueryMode.refresh),
      builder: (item) => FollowTile(item.targetId),
    );
  }
}
