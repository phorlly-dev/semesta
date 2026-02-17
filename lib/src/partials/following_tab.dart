import 'package:flutter/material.dart';
import 'package:semesta/public/helpers/generic_helper.dart';
import 'package:semesta/public/mixins/repository_mixin.dart';
import 'package:semesta/public/helpers/utils_helper.dart';
import 'package:semesta/src/components/global/cached_tab.dart';
import 'package:semesta/src/components/global/feed_threaded.dart';

class FollowingTab extends StatelessWidget {
  final ScrollController? scroller;
  const FollowingTab({super.key, this.scroller});

  @override
  Widget build(BuildContext context) {
    final kf = getKey(id: pctrl.currentUid, screen: Screen.following);
    return CachedTab(
      controller: pctrl,
      scroller: scroller,
      cache: pctrl.stateFor(kf),
      message: "There's no posts in following yet.",
      onInit: pctrl.loadMoreFollowing,
      onMore: () => pctrl.loadMoreFollowing(QueryMode.next),
      onRefresh: () => pctrl.loadMoreFollowing(QueryMode.refresh),
      builder: (item) => SyncFeedThreaded(item),
    );
  }
}
