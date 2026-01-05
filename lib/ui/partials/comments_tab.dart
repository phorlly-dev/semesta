import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:semesta/core/controllers/post_controller.dart';
import 'package:semesta/core/mixins/repo_mixin.dart';
import 'package:semesta/core/views/feed_view.dart';
import 'package:semesta/ui/components/globals/cached_tab.dart';
import 'package:semesta/ui/components/globals/live_feed.dart';

class CommentsTab extends StatelessWidget {
  final String uid;
  const CommentsTab({super.key, required this.uid});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PostController>();
    return CachedTab<FeedView>(
      controller: controller,
      cache: controller.stateFor('profile:$uid:comments'),
      emptyMessage: "There's no replies yet.",
      onInitial: () => controller.loadUserComments(uid),
      onMore: () => controller.loadUserComments(uid, QueryMode.next),
      onRefresh: () => controller.loadUserComments(uid, QueryMode.refresh),
      itemBuilder: (item) {
        return LiveFeed(feed: item.copy(uid: uid), me: true);
      },
    );
  }
}
