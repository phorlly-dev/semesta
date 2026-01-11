import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:semesta/core/views/generic_helper.dart';
import 'package:semesta/core/mixins/repo_mixin.dart';
import 'package:semesta/core/views/feed_view.dart';
import 'package:semesta/core/views/utils_helper.dart';
import 'package:semesta/ui/components/globals/cached_tab.dart';
import 'package:semesta/ui/widgets/media_display.dart';

class MediaTab extends StatelessWidget {
  final String uid;
  const MediaTab({super.key, required this.uid});

  @override
  Widget build(BuildContext context) {
    return CachedTab<FeedView>(
      isGrid: true,
      controller: pctrl,
      cache: pctrl.stateFor(getKey(uid: uid, screen: Screen.media)),
      emptyMessage: "There's no media yet.",
      onInitial: () => pctrl.loadUserMedia(uid),
      onMore: () => pctrl.loadUserMedia(uid, QueryMode.next),
      onRefresh: () => pctrl.loadUserMedia(uid, QueryMode.refresh),
      itemBuilder: (item) {
        final post = item.feed;
        return MediaDisplay(
          size: 32,
          media: post.media[0],
          onTap: () async {
            await context.pushNamed(
              route.media.name,
              pathParameters: {'id': post.id},
              queryParameters: {'index': '0'},
            );
          },
        );
      },
    );
  }
}
