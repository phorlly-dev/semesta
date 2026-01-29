import 'package:flutter/widgets.dart';
import 'package:semesta/app/models/feed.dart';
import 'package:semesta/public/extensions/controller_extension.dart';
import 'package:semesta/public/helpers/feed_view.dart';
import 'package:semesta/public/helpers/generic_helper.dart';
import 'package:semesta/src/components/global/loading_skelenton.dart';
import 'package:semesta/src/components/info/core_post_card.dart';
import 'package:semesta/src/components/info/reference_to_post.dart';
import 'package:semesta/src/components/info/reposted_banner.dart';
import 'package:semesta/src/widgets/sub/direction_y.dart';

enum RenderStyle {
  threaded, // connected to parent
  reference, // standalone activity
}

class CommentedContext extends StatelessWidget {
  final Feed? parent;
  final bool profiled, hasActions;
  final StateView _state;
  final RenderStyle style;
  final double startedLine, ededLine;
  const CommentedContext(
    this._state, {
    super.key,
    this.parent,
    this.profiled = false,
    this.style = RenderStyle.threaded,
    this.hasActions = true,
    this.startedLine = 52,
    this.ededLine = 394,
  });

  @override
  Widget build(BuildContext context) {
    final status = _state.status;
    final actions = _state.actions;
    final state = StateView(status, actions);

    return switch (style) {
      RenderStyle.reference => CorePostCard(
        state,
        profiled: profiled,
        above: RepostedBanner(actions.target),
        reference: ReferenceToPost(parent?.uid ?? status.author.id),
      ),

      RenderStyle.threaded =>
        parent == null
            ? const SizedBox.shrink()
            : StreamBuilder(
                stream: actrl.state$(parent!),
                builder: (_, snapshot) {
                  if (!snapshot.hasData) return const LoadingSkelenton();

                  final sts = snapshot.data!;
                  return DirectionY(
                    children: [
                      CorePostCard(
                        StateView(sts.status, sts.actions),
                        primary: true,
                        profiled: profiled,
                        endedLine: ededLine,
                        startedLine: startedLine,
                        above: RepostedBanner(actions.target, uid: parent?.uid),
                      ),

                      if (hasActions) CorePostCard(state, profiled: profiled),
                    ],
                  );
                },
              ),
    };
  }
}
