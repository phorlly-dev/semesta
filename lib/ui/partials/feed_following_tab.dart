import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:semesta/core/mixins/repo_mixin.dart';
import 'package:semesta/core/controllers/post_controller.dart';
import 'package:semesta/core/views/feed_view.dart';
import 'package:semesta/ui/components/globals/cached_tab.dart';
import 'package:semesta/ui/components/globals/live_feed.dart';

class FeedFollowingTab extends StatelessWidget {
  final ScrollController scroller;
  const FeedFollowingTab({super.key, required this.scroller});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PostController>();
    final userIds = controller.followingIds;
    return CachedTab<FeedView>(
      controller: controller,
      cache: controller.stateFor('home:following'),
      emptyMessage: "There's no posts in following yet.",
      onInitial: () => controller.loadMoreFollowing(userIds),
      onMore: () => controller.loadMoreFollowing(userIds, QueryMode.next),
      onRefresh: () => controller.loadMoreFollowing(userIds, QueryMode.refresh),
      itemBuilder: (item) => LiveFeed(feed: item),
    );
  }
}
