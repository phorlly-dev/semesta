import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:semesta/public/extensions/controller_extension.dart';
import 'package:semesta/public/helpers/generic_helper.dart';
import 'package:semesta/src/components/layout/_home.dart';
import 'package:semesta/src/partials/following_tab.dart';
import 'package:semesta/src/partials/feeds_tab.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final user = pctrl.currentUser;
      final index = dctrl.index;
      final scrollers = dctrl.controllers;
      final visible = dctrl.visible.value;

      return HomeLayout(
        user.avatar,
        visible: visible,
        onLogo: () => dctrl.jump,
        children: [FeedsTab(scrollers[0]), FollowingTab(scrollers[1])],
        onTap: (idx) async {
          if (index.value != idx) index.value = idx;
          if (idx == 1) {
            final meta = pctrl.metaFor('home:following');
            if (meta.dirty) {
              await pctrl.refreshFollowing;
              meta.dirty = false;
            }
          }
        },
      );
    });
  }
}
