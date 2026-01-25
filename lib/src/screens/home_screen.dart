import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:semesta/public/extensions/controller_extension.dart';
import 'package:semesta/public/helpers/generic_helper.dart';
import 'package:semesta/src/components/layout/home_layout.dart';
import 'package:semesta/src/partials/feed_following_tab.dart';
import 'package:semesta/src/partials/feed_for_you_tab.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final user = pctrl.currentUser;
      final curIdx = dctrl.currentIndex;
      final isVisible = dctrl.isVisible.value;
      final scrollers = dctrl.scrollControllers;

      return HomeLayout(
        isVisible: isVisible,
        avatar: user.avatar,
        onLogo: () => dctrl.jump,
        children: [FeedForYouTab(scrollers[0]), FeedFollowingTab(scrollers[1])],
        onTap: (idx) async {
          if (curIdx.value != idx) curIdx.value = idx;
          if (idx == 1) {
            final meta = pctrl.metaFor('home:following');
            if (meta.dirty) {
              await pctrl.refreshFollowing();
              meta.dirty = false;
            }
          }
        },
      );
    });
  }
}
