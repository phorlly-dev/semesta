import 'package:flutter/material.dart';
import 'package:semesta/app/extensions/controller_extension.dart';
import 'package:semesta/core/views/generic_helper.dart';
import 'package:semesta/core/mixins/repo_mixin.dart';
import 'package:semesta/core/views/feed_view.dart';
import 'package:semesta/core/views/utils_helper.dart';
import 'package:semesta/ui/components/globals/cached_tab.dart';
import 'package:semesta/ui/components/globals/live_feed.dart';

class PostsTab extends StatelessWidget {
  final String uid;
  const PostsTab({super.key, required this.uid});

  @override
  Widget build(BuildContext context) {
    final key = getKey(uid: uid, screen: Screen.post);
    return CachedTab<FeedView>(
      controller: pctrl,
      cache: pctrl.stateFor(key),
      emptyMessage: "There's no posts yet.",
      onInitial: () => pctrl.combinePosts(uid),
      onMore: () => pctrl.combinePosts(uid, QueryMode.next),
      onRefresh: () {
        final meta = pctrl.metaFor(key);
        if (meta.dirty) {
          pctrl.stateFor(key).clear();
          meta.dirty = false;
        }

        return pctrl.combinePosts(uid, QueryMode.refresh);
      },
      itemBuilder: (item) => LiveFeed(feed: item, primary: false),
    );
  }
}
