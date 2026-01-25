import 'package:flutter/material.dart';
import 'package:semesta/public/helpers/generic_helper.dart';
import 'package:semesta/public/mixins/repo_mixin.dart';
import 'package:semesta/public/helpers/feed_view.dart';
import 'package:semesta/public/helpers/utils_helper.dart';
import 'package:semesta/src/components/layout/_layout_page.dart';
import 'package:semesta/src/components/layout/custom_app_bar.dart';
import 'package:semesta/src/components/global/cached_tab.dart';
import 'package:semesta/src/components/global/live_feed.dart';

class LikedPage extends StatelessWidget {
  final String _uid;
  const LikedPage(this._uid, {super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutPage(
      header: CustomAppBar(
        middle: Text('Liked', style: TextStyle(fontSize: 20)),
      ),
      content: CachedTab<FeedView>(
        isBreak: true,
        controller: pctrl,
        cache: pctrl.stateFor(getKey(id: _uid, screen: Screen.favorite)),
        emptyMessage: "There's no liked yet.",
        onInitial: () => pctrl.loadUserFavorites(_uid),
        onMore: () => pctrl.loadUserFavorites(_uid, QueryMode.next),
        onRefresh: () => pctrl.loadUserFavorites(_uid, QueryMode.refresh),
        builder: (item) => LiveFeed(item),
      ),
    );
  }
}
