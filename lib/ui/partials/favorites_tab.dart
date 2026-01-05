import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:semesta/core/mixins/repo_mixin.dart';
import 'package:semesta/core/controllers/post_controller.dart';
import 'package:semesta/core/views/feed_view.dart';
import 'package:semesta/ui/components/globals/cached_tab.dart';
import 'package:semesta/ui/components/globals/live_feed.dart';

class FavoritesTab extends StatelessWidget {
  final String uid;
  const FavoritesTab({super.key, required this.uid});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PostController>();
    return CachedTab<FeedView>(
      autoLoad: false,
      controller: controller,
      cache: controller.stateFor('profile:$uid:favorites'),
      emptyMessage: "There's no likes yet.",
      onInitial: () => controller.loadUserFavorites(uid),
      onMore: () => controller.loadUserFavorites(uid, QueryMode.next),
      onRefresh: () => controller.loadUserFavorites(uid, QueryMode.refresh),
      itemBuilder: (item) {
        return LiveFeed(feed: item, me: true);
      },
    );
  }
}
