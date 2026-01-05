import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:semesta/core/mixins/repo_mixin.dart';
import 'package:semesta/core/controllers/user_controller.dart';
import 'package:semesta/core/views/audit_view.dart';
import 'package:semesta/ui/components/users/follow_tile.dart';
import 'package:semesta/ui/components/globals/cached_tab.dart';

class FollowingTab extends StatelessWidget {
  final String uid;
  const FollowingTab({super.key, required this.uid});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<UserController>();
    return CachedTab<AuthedView>(
      controller: controller,
      cache: controller.stateFor('follow:$uid:following'),
      emptyMessage: "There's no followings yet.",
      onInitial: () => controller.loadUserFollowing(uid),
      onMore: () => controller.loadUserFollowing(uid, QueryMode.next),
      onRefresh: () => controller.loadUserFollowing(uid, QueryMode.refresh),
      itemBuilder: (item) => FollowTile(uid: item.currentId),
    );
  }
}
