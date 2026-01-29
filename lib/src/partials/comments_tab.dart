import 'package:flutter/material.dart';
import 'package:semesta/public/extensions/controller_extension.dart';
import 'package:semesta/public/helpers/generic_helper.dart';
import 'package:semesta/public/mixins/repo_mixin.dart';
import 'package:semesta/public/helpers/utils_helper.dart';
import 'package:semesta/src/components/global/cached_tab.dart';
import 'package:semesta/src/components/global/live_feed_threaded.dart';

class CommentsTab extends StatelessWidget {
  final String _uid;
  const CommentsTab(this._uid, {super.key});

  @override
  Widget build(BuildContext context) {
    final key = getKey(id: _uid, screen: Screen.comment);
    final state = pctrl.stateFor(key);
    return CachedTab(
      controller: pctrl,
      cache: state,
      emptyMessage: "There's no replies yet.",
      onInitial: () => pctrl.combineFeeds(_uid),
      onMore: () => pctrl.combineFeeds(_uid, QueryMode.next),
      onRefresh: () {
        final meta = pctrl.metaFor(key);
        if (meta.dirty) {
          state.clear();
          meta.dirty = false;
        }

        return pctrl.combineFeeds(_uid, QueryMode.refresh);
      },
      builder: (item) => LiveFeedThreaded(item, profiled: true),
    );
  }
}
