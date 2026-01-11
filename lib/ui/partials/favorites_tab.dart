import 'package:flutter/material.dart';
import 'package:semesta/core/views/generic_helper.dart';
import 'package:semesta/core/mixins/repo_mixin.dart';
import 'package:semesta/core/views/feed_view.dart';
import 'package:semesta/core/views/utils_helper.dart';
import 'package:semesta/ui/components/globals/cached_tab.dart';
import 'package:semesta/ui/components/globals/live_feed.dart';

class FavoritesTab extends StatelessWidget {
  final String uid;
  const FavoritesTab({super.key, required this.uid});

  @override
  Widget build(BuildContext context) {
    return CachedTab<FeedView>(
      controller: pctrl,
      cache: pctrl.stateFor(getKey(uid: uid, screen: Screen.favorite)),
      emptyMessage: "There's no likes yet.",
      onInitial: () => pctrl.loadUserFavorites(uid),
      onMore: () => pctrl.loadUserFavorites(uid, QueryMode.next),
      onRefresh: () => pctrl.loadUserFavorites(uid, QueryMode.refresh),
      itemBuilder: (item) {
        return LiveFeed(feed: item, primary: false);
      },
    );
  }
}
