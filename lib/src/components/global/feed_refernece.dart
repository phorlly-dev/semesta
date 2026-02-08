import 'package:flutter/material.dart';
import 'package:semesta/app/models/feed.dart';
import 'package:semesta/public/extensions/controller_extension.dart';
import 'package:semesta/public/helpers/generic_helper.dart';
import 'package:semesta/public/helpers/feed_view.dart';
import 'package:semesta/src/components/global/card_skeleton.dart';
import 'package:semesta/src/components/info/commented_context.dart';
import 'package:semesta/src/components/info/core_post_card.dart';
import 'package:semesta/src/components/info/quoted_context.dart';
import 'package:semesta/src/components/info/reposted_banner.dart';

class SyncFeedRefernece extends StatelessWidget {
  final FeedView _feed;
  final bool profiled;
  const SyncFeedRefernece(this._feed, {super.key, this.profiled = false});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: actrl.feed$(_feed),
      builder: (_, snapshot) {
        if (!snapshot.hasData) return const CardSkeleton(); // 👈 smooth loading

        final state = snapshot.data!;
        final content = state.content;
        final status = state.status;
        final actions = state.actions;
        final view = StateView(status, actions);

        return switch (content.feed.type) {
          Create.quote => CorePostCard(
            view,
            profiled: profiled,
            uid: content.uid,
            above: RepostedBanner(actions.target, uid: content.uid),
            middle: QuotedContext(quoted: content.parent, actor: content.actor),
          ),

          Create.reply => CommentedContext(
            view,
            profiled: profiled,
            parent: content.parent,
            style: RenderStyle.reference,
          ),

          Create.post => CorePostCard(
            view,
            profiled: profiled,
            uid: content.uid,
            above: RepostedBanner(actions.target, uid: content.uid),
          ),
        };
      },
    );
  }
}
