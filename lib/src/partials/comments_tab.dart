import 'package:flutter/material.dart';
import 'package:semesta/public/extensions/controller_extension.dart';
import 'package:semesta/public/helpers/generic_helper.dart';
import 'package:semesta/public/mixins/repo_mixin.dart';
import 'package:semesta/public/helpers/feed_view.dart';
import 'package:semesta/public/helpers/utils_helper.dart';
import 'package:semesta/src/components/global/cached_tab.dart';
import 'package:semesta/src/components/global/live_feed.dart';

class CommentsTab extends StatelessWidget {
  final String _uid;
  const CommentsTab(this._uid, {super.key});

  @override
  Widget build(BuildContext context) {
    return CachedTab<FeedView>(
      controller: pctrl,
      cache: pctrl.stateFor(getKey(id: _uid, screen: Screen.comment)),
      emptyMessage: "There's no replies yet.",
      onInitial: () => pctrl.combineFeeds(_uid),
      onMore: () => pctrl.combineFeeds(_uid, QueryMode.next),
      onRefresh: () => pctrl.combineFeeds(_uid, QueryMode.refresh),
      builder: (item) {
        return LiveFeed(item, primary: false);
      },
    );
  }
}
