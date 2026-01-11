import 'package:flutter/material.dart';
import 'package:semesta/core/views/generic_helper.dart';
import 'package:semesta/core/mixins/repo_mixin.dart';
import 'package:semesta/core/views/feed_view.dart';
import 'package:semesta/core/views/utils_helper.dart';
import 'package:semesta/ui/components/globals/cached_tab.dart';
import 'package:semesta/ui/components/globals/live_feed.dart';

class FeedFollowingTab extends StatelessWidget {
  final ScrollController scroller;
  const FeedFollowingTab({super.key, required this.scroller});

  @override
  Widget build(BuildContext context) {
    return CachedTab<FeedView>(
      controller: pctrl,
      cache: pctrl.stateFor(getKey(screen: Screen.following)),
      emptyMessage: "There's no posts in following yet.",
      onInitial: pctrl.loadMoreFollowing,
      onMore: () => pctrl.loadMoreFollowing(QueryMode.next),
      onRefresh: () => pctrl.loadMoreFollowing(QueryMode.refresh),
      itemBuilder: (item) => LiveFeed(feed: item),
    );
  }
}
