import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:semesta/app/extensions/controller_extension.dart';
import 'package:semesta/core/mixins/repo_mixin.dart';
import 'package:semesta/core/controllers/post_controller.dart';
import 'package:semesta/core/views/feed_view.dart';
import 'package:semesta/ui/components/globals/cached_tab.dart';
import 'package:semesta/ui/components/globals/live_feed.dart';

class PostsTab extends StatelessWidget {
  final String uid;
  const PostsTab({super.key, required this.uid});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PostController>();
    return CachedTab<FeedView>(
      autoLoad: false,
      controller: controller,
      cache: controller.stateFor('profile:$uid:posts'),
      emptyMessage: "There's no posts yet.",
      onInitial: () => controller.combinePosts(uid),
      onMore: () => controller.combinePosts(uid, QueryMode.next),
      onRefresh: () {
        final meta = controller.metaFor('profile:$uid:posts');
        if (meta.dirty) {
          controller.stateFor('profile:$uid:posts').clear();
          meta.dirty = false;
        }

        return controller.combinePosts(uid, QueryMode.refresh);
      },
      itemBuilder: (item) => LiveFeed(feed: item, me: true),
    );
  }
}
