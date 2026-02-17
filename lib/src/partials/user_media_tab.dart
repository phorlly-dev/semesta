import 'package:flutter/material.dart';
import 'package:semesta/public/extensions/context_extension.dart';
import 'package:semesta/public/helpers/generic_helper.dart';
import 'package:semesta/public/mixins/repository_mixin.dart';
import 'package:semesta/public/helpers/utils_helper.dart';
import 'package:semesta/src/components/global/cached_tab.dart';
import 'package:semesta/src/widgets/main/imaged_render.dart';

class UserMediaTab extends StatelessWidget {
  final String _uid;
  const UserMediaTab(this._uid, {super.key});

  @override
  Widget build(BuildContext context) {
    return CachedTab(
      isGrid: true,
      controller: pctrl,
      cache: pctrl.stateFor(getKey(id: _uid, screen: Screen.media)),
      message: "There's no media yet.",
      onInit: () => pctrl.loadUserMedia(_uid),
      onMore: () => pctrl.loadUserMedia(_uid, QueryMode.next),
      onRefresh: () => pctrl.loadUserMedia(_uid, QueryMode.refresh),
      builder: (item) {
        final post = item.feed;
        return ImagedRender(
          post.media[0],
          size: 32,
          onTap: () async {
            await context.openPreview(routes.media, post.id, 0);
          },
        );
      },
    );
  }
}
