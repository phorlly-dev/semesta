import 'package:flutter/material.dart';
import 'package:semesta/public/helpers/generic_helper.dart';
import 'package:semesta/public/mixins/repo_mixin.dart';
import 'package:semesta/public/helpers/feed_view.dart';
import 'package:semesta/public/helpers/utils_helper.dart';
import 'package:semesta/src/components/global/cached_tab.dart';
import 'package:semesta/src/components/global/live_feed.dart';

class FeedFollowingTab extends StatelessWidget {
  final ScrollController _scroller;
  const FeedFollowingTab(this._scroller, {super.key});

  @override
  Widget build(BuildContext context) {
    return CachedTab<FeedView>(
      controller: pctrl,
      scroller: _scroller,
      cache: pctrl.stateFor(
        getKey(id: pctrl.currentUid, screen: Screen.following),
      ),
      emptyMessage: "There's no posts in following yet.",
      onInitial: pctrl.loadMoreFollowing,
      onMore: () => pctrl.loadMoreFollowing(QueryMode.next),
      onRefresh: () => pctrl.loadMoreFollowing(QueryMode.refresh),
      builder: (item) => LiveFeed(item),
    );
  }
}
