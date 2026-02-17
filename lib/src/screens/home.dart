import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:semesta/public/extensions/context_extension.dart';
import 'package:semesta/public/extensions/controller_extension.dart';
import 'package:semesta/public/helpers/generic_helper.dart';
import 'package:semesta/public/helpers/params_helper.dart';
import 'package:semesta/public/utils/scroll_aware.dart';
import 'package:semesta/src/components/layout/_page.dart';
import 'package:semesta/src/components/layout/_tab.dart';
import 'package:semesta/src/components/layout/nav_bar.dart';
import 'package:semesta/src/partials/following_tab.dart';
import 'package:semesta/src/partials/feeds_tab.dart';
import 'package:semesta/src/widgets/sub/animated_avatar.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ScrollAware(
      (value) => Obx(() {
        final user = pctrl.currentUser;
        final scrollers = dctrl.controllers;

        return TabLayout(
          tabs: ['For you', 'Following'],
          builder: (ctrl, tab) => PageLayout(
            header: value
                ? AppNavBar(
                    height: 88,
                    start: AnimatedAvatar(
                      MediaSource.network(user.media.url),
                      size: 32,
                      padding: const EdgeInsets.all(4.0),
                      onTap: () => Scaffold.of(context).openDrawer(),
                    ),
                    middle: GestureDetector(
                      onTap: dctrl.jump,
                      child: Text(
                        'Semesta',
                        style: TextStyle(
                          color: context.primaryColor,
                          fontWeight: FontWeight.w700,
                          fontSize: 20,
                        ),
                      ),
                    ),
                    end: IconButton(
                      color: context.outlineColor,
                      onPressed: () {},
                      icon: Icon(Icons.search, size: 26),
                    ),
                    bottom: tab,
                  )
                : null,
            content: TabBarView(
              controller: ctrl,
              children: [
                FeedsTab(scroller: scrollers[0]),
                FollowingTab(scroller: scrollers[1]),
              ],
            ),
          ),
          onTap: (idx) async {
            dctrl.index.value = idx;
            dctrl.visible.value = true;

            if (idx == 1) {
              final meta = pctrl.metaFor('home:following');
              if (meta.dirty) {
                await pctrl.refreshFollowing();
                meta.dirty = false;
              }
            }
          },
        );
      }),
    );
  }
}
