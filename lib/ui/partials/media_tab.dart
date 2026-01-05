import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:semesta/app/routes/routes.dart';
import 'package:semesta/core/mixins/repo_mixin.dart';
import 'package:semesta/core/controllers/post_controller.dart';
import 'package:semesta/core/views/feed_view.dart';
import 'package:semesta/ui/components/globals/cached_tab.dart';
import 'package:semesta/ui/widgets/media_display.dart';

class MediaTab extends StatelessWidget {
  final String uid;
  const MediaTab({super.key, required this.uid});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PostController>();
    return CachedTab<FeedView>(
      autoLoad: false,
      isGrid: true,
      controller: controller,
      cache: controller.stateFor('profile:$uid:media'),
      emptyMessage: "There's no media yet.",
      onInitial: () => controller.loadUserMedia(uid),
      onMore: () => controller.loadUserMedia(uid, QueryMode.next),
      onRefresh: () => controller.loadUserMedia(uid, QueryMode.refresh),
      itemBuilder: (item) {
        final post = item.feed;
        return MediaDisplay(
          size: 32,
          media: post.media[0],
          onTap: () async {
            await context.pushNamed(
              Routes().imagesPreview.name,
              pathParameters: {'id': item.currentId},
              queryParameters: {'index': '0'},
            );
          },
        );
      },
    );
  }
}
