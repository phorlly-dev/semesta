import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:semesta/core/controllers/post_controller.dart';
import 'package:semesta/ui/components/global/public_post_card.dart';
import 'package:semesta/ui/widgets/keep_alive_client.dart';
import 'package:semesta/ui/widgets/list_generated.dart';

class FeedForYouTab extends StatelessWidget {
  final ScrollController scroller;
  const FeedForYouTab({super.key, required this.scroller});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PostController>();

    return KeepAliveClient(
      child: Obx(() {
        final posts = controller.postsForYou;
        final isLoading = controller.isLoading.value;

        return ListGenerated(
          scroller: scroller,
          counter: posts.length,
          builder: (idx) => PublicPostCard(post: posts[idx]),
          onRefresh: () async => await controller.loadMoreForYou(),
          isLoading: isLoading,
          isEmpty: posts.isEmpty,
        );
      }),
    );
  }
}
