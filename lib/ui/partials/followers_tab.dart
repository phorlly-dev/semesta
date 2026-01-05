import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:semesta/core/mixins/repo_mixin.dart';
import 'package:semesta/core/controllers/user_controller.dart';
import 'package:semesta/core/views/audit_view.dart';
import 'package:semesta/ui/components/users/follow_tile.dart';
import 'package:semesta/ui/components/globals/cached_tab.dart';

class FollowersTab extends StatelessWidget {
  final String uid;
  const FollowersTab({super.key, required this.uid});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<UserController>();
    return CachedTab<AuthedView>(
      controller: controller,
      cache: controller.stateFor('follow:$uid:followers'),
      emptyMessage: "There's no followers yet.",
      onInitial: () => controller.loadUserFollowers(uid),
      onMore: () => controller.loadUserFollowers(uid, QueryMode.next),
      onRefresh: () => controller.loadUserFollowers(uid, QueryMode.refresh),
      itemBuilder: (item) => FollowTile(uid: item.currentId),
    );
  }
}
