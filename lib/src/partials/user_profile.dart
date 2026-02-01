import 'package:flutter/material.dart';
import 'package:semesta/public/extensions/controller_extension.dart';
import 'package:semesta/public/extensions/extension.dart';
import 'package:semesta/public/helpers/generic_helper.dart';
import 'package:semesta/public/helpers/utils_helper.dart';
import 'package:semesta/public/utils/params.dart';
import 'package:semesta/public/utils/scroll_aware_app_bar.dart';
import 'package:semesta/src/components/layout/tab_sliver.dart';
import 'package:semesta/src/components/layout/nav_bar_sliver.dart';
import 'package:semesta/src/components/layout/nested_scrollable.dart';
import 'package:semesta/src/components/layout/_tab.dart';
import 'package:semesta/src/components/user/profile_header.dart';
import 'package:semesta/src/components/global/animated_card.dart';
import 'package:semesta/src/components/user/profile_info.dart';

class UserProfile extends StatelessWidget {
  final bool authed;
  final String _uid;
  final int initIndex;
  final List<Widget> children;
  final ValueChanged<int>? onTap;
  final int postCount, mediaCount;
  const UserProfile(
    this._uid, {
    super.key,
    this.children = const [],
    this.onTap,
    this.authed = false,
    this.initIndex = 0,
    this.postCount = 0,
    this.mediaCount = 0,
  });

  CountState get _count => switch (initIndex) {
    2 => CountState.render(mediaCount, FeedKind.media),
    _ => CountState.render(postCount),
  };

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: actrl.status$(_uid),
      builder: (_, snapshot) {
        if (!snapshot.hasData) return const AnimatedCard();

        final state = snapshot.data!;
        final authed = state.authed;
        final author = state.author;

        return TabLayout(
          onTap: onTap,
          index: initIndex,
          tabs: ['Posts', 'Replies', 'Media'],
          builder: (ctrl, tab) => AnimatedBuilder(
            animation: state,
            builder: (_, child) => NestedScrollable(
              builder: (_) => [
                ScrollAwareAppBar(
                  (visible) => AppNavBarSliver(
                    middle: Text(authed ? 'Your profile' : author.name),
                    end: authed
                        ? IconButton(
                            onPressed: () {},
                            icon: Icon(Icons.settings),
                            color: context.outlineColor,
                          )
                        : IconButton(
                            onPressed: () {},
                            icon: Icon(Icons.search),
                            color: context.outlineColor,
                          ),
                    toolbarHeight: visible ? kToolbarHeight : 0,
                  ),
                ),

                ProfileHeader(author, authed: authed),

                // Profile info section
                SliverToBoxAdapter(child: ProfileInfo(_count, state)),

                // Tab bar section
                TabSliver(tab),
              ],
              child: TabBarView(controller: ctrl, children: children),
            ),
          ),
        );
      },
    );
  }
}
