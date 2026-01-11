import 'package:flutter/material.dart';
import 'package:semesta/app/extensions/controller_extension.dart';
import 'package:semesta/core/views/generic_helper.dart';
import 'package:semesta/core/mixins/repo_mixin.dart';
import 'package:semesta/core/views/feed_view.dart';
import 'package:semesta/core/views/utils_helper.dart';
import 'package:semesta/ui/components/globals/cached_tab.dart';
import 'package:semesta/ui/components/globals/live_feed.dart';

class CommentsTab extends StatelessWidget {
  final String uid;
  const CommentsTab({super.key, required this.uid});

  @override
  Widget build(BuildContext context) {
    return CachedTab<FeedView>(
      controller: pctrl,
      cache: pctrl.stateFor(getKey(uid: uid, screen: Screen.comment)),
      emptyMessage: "There's no replies yet.",
      onInitial: () => pctrl.combineFeeds(uid),
      onMore: () => pctrl.combineFeeds(uid, QueryMode.next),
      onRefresh: () => pctrl.combineFeeds(uid, QueryMode.refresh),
      itemBuilder: (item) {
        return LiveFeed(feed: item, primary: false);
      },
    );
  }
}
