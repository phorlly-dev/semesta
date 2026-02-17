import 'package:flutter/material.dart';
import 'package:semesta/public/helpers/generic_helper.dart';
import 'package:semesta/public/mixins/repository_mixin.dart';
import 'package:semesta/public/helpers/utils_helper.dart';
import 'package:semesta/src/components/global/cached_tab.dart';
import 'package:semesta/src/components/global/feed_refernece.dart';

class CommentsList extends StatelessWidget {
  final String _pid;
  const CommentsList(this._pid, {super.key});

  @override
  Widget build(BuildContext context) {
    return CachedTab(
      controller: pctrl,
      onInit: () => pctrl.loadPostComments(_pid),
      message: "There's no replies yet.",
      cache: pctrl.stateFor(getKey(id: _pid, screen: Screen.detail)),
      onMore: () => pctrl.loadPostComments(_pid, QueryMode.next),
      builder: (item) => SyncFeedRefernece(item),
    );
  }
}
