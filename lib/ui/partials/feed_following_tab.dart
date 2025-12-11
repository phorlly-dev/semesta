import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:semesta/core/controllers/post_controller.dart';
import 'package:semesta/ui/components/global/public_post_card.dart';
import 'package:semesta/ui/widgets/keep_alive_client.dart';
import 'package:semesta/ui/widgets/list_generated.dart';

class FeedFollowingTab extends StatelessWidget {
  final ScrollController scroller;
  const FeedFollowingTab({super.key, required this.scroller});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PostController>();

    return KeepAliveClient(
      child: Obx(() {
        final posts = controller.postsFollowing;
        final isLoading = controller.isLoading.value;
        final ids = controller.followings.toList();

        return ListGenerated(
          scroller: scroller,
          counter: posts.length,
          builder: (idx) => PublicPostCard(post: posts[idx]),
          isEmpty: posts.isEmpty,
          isLoading: isLoading,
          message: "There's no post in following yet.",
          onRefresh: () async {
            await controller.loadMoreFollowing(ids);
          },
        );
      }),
    );
  }
}
