import 'package:flutter/material.dart';
import 'package:semesta/app/extensions/controller_extension.dart';
import 'package:semesta/core/views/generic_helper.dart';
import 'package:semesta/core/views/feed_view.dart';
import 'package:semesta/ui/components/layouts/card_skeleton.dart';
import 'package:semesta/ui/components/globals/post_card.dart';

class LiveFeed extends StatelessWidget {
  final FeedView feed;
  final bool primary;
  const LiveFeed({super.key, required this.feed, this.primary = true});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<FeedStateView>(
      stream: actrl.feedStream$(feed),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const CardSkeleton(); // 👈 smooth loading
        }

        final state = snapshot.data!;
        return PostCard(state: state, primary: primary);
      },
    );
  }
}
