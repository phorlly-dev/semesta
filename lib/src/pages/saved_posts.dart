import 'package:flutter/material.dart';
import 'package:semesta/public/helpers/generic_helper.dart';
import 'package:semesta/public/mixins/repo_mixin.dart';
import 'package:semesta/public/helpers/utils_helper.dart';
import 'package:semesta/src/components/layout/_page.dart';
import 'package:semesta/src/components/layout/nav_bar.dart';
import 'package:semesta/src/components/global/cached_tab.dart';
import 'package:semesta/src/components/global/feed_refernece.dart';

class SavedPostsPage extends StatelessWidget {
  final String _uid;
  const SavedPostsPage(this._uid, {super.key});

  @override
  Widget build(BuildContext context) {
    return PageLayout(
      header: AppNavBar(middle: Text('Saved', style: TextStyle(fontSize: 20))),
      content: CachedTab(
        isBreak: true,
        controller: pctrl,
        cache: pctrl.stateFor(getKey(id: _uid, screen: Screen.bookmark)),
        message: "There's no liked yet.",
        onInit: () => pctrl.loadUserBookmarks(_uid),
        onMore: () => pctrl.loadUserBookmarks(_uid, QueryMode.next),
        onRefresh: () => pctrl.loadUserBookmarks(_uid, QueryMode.refresh),
        builder: (item) => SyncFeedRefernece(item),
      ),
    );
  }
}
