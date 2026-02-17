import 'package:flutter/material.dart';
import 'package:semesta/public/extensions/controller_extension.dart';
import 'package:semesta/public/helpers/generic_helper.dart';
import 'package:semesta/public/mixins/repository_mixin.dart';
import 'package:semesta/public/helpers/utils_helper.dart';
import 'package:semesta/src/components/global/cached_tab.dart';
import 'package:semesta/src/components/global/feed_refernece.dart';

class UserPostsTab extends StatelessWidget {
  final String _uid;
  const UserPostsTab(this._uid, {super.key});

  @override
  Widget build(BuildContext context) {
    final key = getKey(id: _uid, screen: Screen.post);
    final state = pctrl.stateFor(key);
    return CachedTab(
      controller: pctrl,
      cache: state,
      message: "There's no posts yet.",
      onInit: () => pctrl.combinePosts(_uid),
      onMore: () => pctrl.combinePosts(_uid, QueryMode.next),
      onRefresh: () {
        final meta = pctrl.metaFor(key);
        if (meta.dirty) {
          state.clear();
          meta.dirty = false;
        }

        return pctrl.combinePosts(_uid, QueryMode.refresh);
      },
      builder: (item) => SyncFeedRefernece(item, profiled: true),
    );
  }
}
