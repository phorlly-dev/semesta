import 'package:flutter/material.dart';
import 'package:semesta/public/extensions/controller_extension.dart';
import 'package:semesta/public/helpers/generic_helper.dart';
import 'package:semesta/public/helpers/feed_view.dart';
import 'package:semesta/src/components/global/card_skeleton.dart';
import 'package:semesta/src/components/info/core_post_card.dart';

class LiveFeed extends StatelessWidget {
  final FeedView _feed;
  final bool primary;
  const LiveFeed(this._feed, {super.key, this.primary = true});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<FeedStateView>(
      stream: actrl.feedStream$(_feed),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const CardSkeleton(); // 👈 smooth loading
        }

        final state = snapshot.data!;
        return CorePostCard(
          StateView(state.status, state.actions),
          primary: false,
        );
      },
    );
  }
}
