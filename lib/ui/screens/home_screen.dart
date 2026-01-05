import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:semesta/app/extensions/controller_extension.dart';
import 'package:semesta/app/utils/scroll_helper.dart';
import 'package:semesta/core/controllers/post_controller.dart';
import 'package:semesta/ui/components/layouts/home_layout.dart';
import 'package:semesta/ui/partials/feed_following_tab.dart';
import 'package:semesta/ui/partials/feed_for_you_tab.dart';

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

      return HomeLayout(
        isVisible: isVisible,
        avatar: user.avatar,
        onLogo: () => scrollerCtrl.jump,
        children: [
          FeedForYouTab(scroller: scrollers[0]),
          FeedFollowingTab(scroller: scrollers[1]),
        ],
        onTap: (idx) async {
          if (curIdx.value != idx) curIdx.value = idx;
          if (idx == 1) {
            final meta = controller.metaFor('home:following');
            if (meta.dirty) {
              await controller.refreshFollowing();
              meta.dirty = false;
            }
          }
        },
      );
    });
  }
}
