import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:semesta/app/utils/scroll_helper.dart';
import 'package:semesta/core/controllers/post_controller.dart';
import 'package:semesta/ui/components/global/_layout_post.dart';
import 'package:semesta/ui/partials/feed_following_tab.dart';
import 'package:semesta/ui/partials/feed_for_you_tab.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final scrollerCtrl = Get.find<ScrollHelper>();
    final controller = Get.find<PostController>();
    final scrollers = scrollerCtrl.scrollControllers;
    final user = controller.currentUser;

    return Obx(() {
      final isVisible = scrollerCtrl.isVisible.value;
      final curIdx = scrollerCtrl.currentIndex;

      return PostLayout(
        isVisible: isVisible,
        scroller: scrollers[2],
        avatar: user.avatar,
        onLogo: () => scrollerCtrl.jump,
        children: [
          FeedForYouTab(scroller: scrollers[0]),
          FeedFollowingTab(scroller: scrollers[1]),
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
