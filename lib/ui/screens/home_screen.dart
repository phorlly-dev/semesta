import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:semesta/app/utils/scroll_helper.dart';
import 'package:semesta/core/controllers/post_controller.dart';
import 'package:semesta/ui/components/global/_layout_post.dart';
import 'package:semesta/ui/partials/feed_tab.dart';
import 'package:semesta/ui/widgets/list_generated.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final scrollerCtrl = Get.find<ScrollHelper>();
    final controller = Get.find<PostController>();
    final scrollers = scrollerCtrl.scrollControllers;

    return Obx(() {
      final user = controller.currentUser;
      final isVisible = scrollerCtrl.isVisible.value;
      final curIdx = scrollerCtrl.currentIndex;
      final postsForYou = controller.postsForYou;
      final postsFollowing = controller.postsFollowing;

      return PostLayout(
        isVisible: isVisible,
        scroller: scrollers[2],
        avatar: user?.avatar ?? '',
        onLogo: () => scrollerCtrl.jump,
        children: [
          ListGenerated(
            onRefresh: () async => await controller.many(force: true),
            scroller: scrollers[0],
            counter: postsForYou.length,
            builder: (idx) => FeedTab(post: postsForYou[idx]),
            isEmpty: postsForYou.isEmpty,
            textEmpty: "There's no post yet.",
            isLoading: controller.isLoading.value,
          ),

          ListGenerated(
            onRefresh: () async {
              final ids = controller.followingsMap[user?.id] ?? const [];
              await controller.many(
                force: true,
                following: true,
                uids: ids.toList(),
              );
            },
            scroller: scrollers[1],
            counter: postsFollowing.length,
            builder: (idx) => FeedTab(post: postsFollowing[idx]),
            isEmpty: postsFollowing.isEmpty,
            textEmpty: "There's no post in following yet.",
            isLoading: controller.isLoading.value,
          ),
        ],
        onTap: (idx) {
          if (curIdx.value != idx) {
            curIdx.value = idx;
          }
        },
      );
    });
  }
}
