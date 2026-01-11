import 'package:flutter/material.dart';
import 'package:semesta/core/views/generic_helper.dart';
import 'package:semesta/core/mixins/repo_mixin.dart';
import 'package:semesta/core/views/audit_view.dart';
import 'package:semesta/ui/components/users/follow_tile.dart';
import 'package:semesta/ui/components/globals/cached_tab.dart';

class FollowingTab extends StatelessWidget {
  final String uid;
  const FollowingTab({super.key, required this.uid});

  @override
  Widget build(BuildContext context) {
    return CachedTab<AuthedView>(
      controller: uctrl,
      cache: uctrl.stateFor('follow:$uid:following'),
      emptyMessage: "There's no followings yet.",
      onInitial: () => uctrl.loadUserFollowing(uid),
      onMore: () => uctrl.loadUserFollowing(uid, QueryMode.next),
      onRefresh: () => uctrl.loadUserFollowing(uid, QueryMode.refresh),
      itemBuilder: (item) => FollowTile(uid: item.targetId),
    );
  }
}
