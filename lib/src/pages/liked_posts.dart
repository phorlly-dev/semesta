import 'package:flutter/material.dart';
import 'package:semesta/public/helpers/generic_helper.dart';
import 'package:semesta/public/mixins/repo_mixin.dart';
import 'package:semesta/public/helpers/utils_helper.dart';
import 'package:semesta/src/components/layout/_page.dart';
import 'package:semesta/src/components/layout/nav_bar.dart';
import 'package:semesta/src/components/global/cached_tab.dart';
import 'package:semesta/src/components/global/feed_refernece.dart';

class LikedPostsPage extends StatelessWidget {
  final String _uid;
  const LikedPostsPage(this._uid, {super.key});

  @override
  Widget build(BuildContext context) {
    return PageLayout(
      header: AppNavBar(middle: Text('Liked', style: TextStyle(fontSize: 20))),
      content: CachedTab(
        isBreak: true,
        controller: pctrl,
        cache: pctrl.stateFor(getKey(id: _uid, screen: Screen.favorite)),
        message: "There's no liked yet.",
        onInit: () => pctrl.loadUserFavorites(_uid),
        onMore: () => pctrl.loadUserFavorites(_uid, QueryMode.next),
        onRefresh: () => pctrl.loadUserFavorites(_uid, QueryMode.refresh),
        builder: (item) => SyncFeedRefernece(item),
      ),
    );
  }
}
