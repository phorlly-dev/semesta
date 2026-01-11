import 'package:flutter/material.dart';
import 'package:semesta/core/views/generic_helper.dart';
import 'package:semesta/core/mixins/repo_mixin.dart';
import 'package:semesta/core/views/audit_view.dart';
import 'package:semesta/ui/components/users/follow_tile.dart';
import 'package:semesta/ui/components/globals/cached_tab.dart';

class FollowersTab extends StatelessWidget {
  final String uid;
  const FollowersTab({super.key, required this.uid});

  @override
  Widget build(BuildContext context) {
    return CachedTab<AuthedView>(
      controller: uctrl,
      cache: uctrl.stateFor('follow:$uid:followers'),
      emptyMessage: "There's no followers yet.",
      onInitial: () => uctrl.loadUserFollowers(uid),
      onMore: () => uctrl.loadUserFollowers(uid, QueryMode.next),
      onRefresh: () => uctrl.loadUserFollowers(uid, QueryMode.refresh),
      itemBuilder: (item) => FollowTile(uid: item.currentId),
    );
  }
}
