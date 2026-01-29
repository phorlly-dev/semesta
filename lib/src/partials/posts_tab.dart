import 'package:flutter/material.dart';
import 'package:semesta/public/extensions/controller_extension.dart';
import 'package:semesta/public/helpers/generic_helper.dart';
import 'package:semesta/public/mixins/repo_mixin.dart';
import 'package:semesta/public/helpers/utils_helper.dart';
import 'package:semesta/src/components/global/cached_tab.dart';
import 'package:semesta/src/components/global/live_feed_refernece.dart';

class PostsTab extends StatelessWidget {
  final String _uid;
  const PostsTab(this._uid, {super.key});

  @override
  Widget build(BuildContext context) {
    final key = getKey(id: _uid, screen: Screen.post);
    final state = pctrl.stateFor(key);
    return CachedTab(
      controller: pctrl,
      cache: state,
      emptyMessage: "There's no posts yet.",
      onInitial: () => pctrl.combinePosts(_uid),
      onMore: () => pctrl.combinePosts(_uid, QueryMode.next),
      onRefresh: () {
        final meta = pctrl.metaFor(key);
        if (meta.dirty) {
          state.clear();
          meta.dirty = false;
        }

        return pctrl.combinePosts(_uid, QueryMode.refresh);
      },
      builder: (item) => LiveFeedRefernece(item, profiled: true),
    );
  }
}
