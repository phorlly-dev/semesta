import 'package:flutter/material.dart';
import 'package:semesta/public/extensions/extension.dart';
import 'package:semesta/public/helpers/generic_helper.dart';
import 'package:semesta/public/mixins/repo_mixin.dart';
import 'package:semesta/public/helpers/utils_helper.dart';
import 'package:semesta/src/components/global/cached_tab.dart';
import 'package:semesta/src/widgets/main/media_display.dart';

class MediaTab extends StatelessWidget {
  final String _uid;
  const MediaTab(this._uid, {super.key});

  @override
  Widget build(BuildContext context) {
    return CachedTab(
      isGrid: true,
      controller: pctrl,
      cache: pctrl.stateFor(getKey(id: _uid, screen: Screen.media)),
      emptyMessage: "There's no media yet.",
      onInitial: () => pctrl.loadUserMedia(_uid),
      onMore: () => pctrl.loadUserMedia(_uid, QueryMode.next),
      onRefresh: () => pctrl.loadUserMedia(_uid, QueryMode.refresh),
      builder: (item) {
        final post = item.feed;
        return MediaDisplay(
          post.media[0],
          size: 32,
          onTap: () async {
            await context.openPreview(route.media, post.id, 0);
          },
        );
      },
    );
  }
}
