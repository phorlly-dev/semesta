import 'package:flutter/widgets.dart';
import 'package:semesta/app/models/feed.dart';
import 'package:semesta/public/extensions/controller_extension.dart';
import 'package:semesta/public/helpers/feed_view.dart';
import 'package:semesta/public/helpers/generic_helper.dart';
import 'package:semesta/src/components/global/loading_skelenton.dart';
import 'package:semesta/src/components/info/core_post_card.dart';
import 'package:semesta/src/components/info/reference_to_post.dart';
import 'package:semesta/src/components/info/reposted_banner.dart';

enum RenderStyle {
  threaded, // connected to parent
  reference, // standalone activity
}

class CommentCard extends StatelessWidget {
  final Feed _feed;
  final String uid;
  final RenderStyle style;
  final bool profiled;
  const CommentCard(
    this._feed, {
    super.key,
    this.uid = '',
    this.style = RenderStyle.threaded,
    this.profiled = false,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<StateView>(
      stream: actrl.stateSteam$(_feed),
      builder: (_, snapshot) {
        if (!snapshot.hasData) return const LoadingSkelenton();

        final state = snapshot.data!;
        // final status = state.status;
        final actions = state.actions;

        return switch (style) {
          RenderStyle.reference => CorePostCard(
            state,
            primary: false,
            profiled: profiled,
            above: RepostedBanner(actions.target),
            reference: ReferenceToPost(uid: uid),
          ),
          RenderStyle.threaded => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CorePostCard(
                state,
                profiled: profiled,
                above: RepostedBanner(actions.target),
              ),
              CorePostCard(
                state,
                primary: false,
                profiled: profiled,
                above: RepostedBanner(actions.target),
              ),
            ],
          ),
        };
      },
    );
  }
}
