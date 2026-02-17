import 'package:flutter/material.dart';
import 'package:semesta/public/extensions/controller_extension.dart';
import 'package:semesta/app/models/feed.dart';
import 'package:semesta/public/extensions/model_extension.dart';
import 'package:semesta/public/helpers/feed_view.dart';
import 'package:semesta/public/helpers/generic_helper.dart';
import 'package:semesta/src/components/global/animated_card.dart';
import 'package:semesta/src/components/info/commented_context.dart';
import 'package:semesta/src/components/info/quoted_context.dart';
import 'package:semesta/src/components/post/content_section.dart';
import 'package:semesta/src/components/post/footer_section.dart';
import 'package:semesta/src/components/post/header_section.dart';
import 'package:semesta/src/widgets/sub/direction_y.dart';

class SyncPostDetail extends StatelessWidget {
  final Feed _post;
  const SyncPostDetail(this._post, {super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: actrl.state$(_post),
      builder: (_, snapshot) {
        if (!snapshot.hasData) return const AnimatedCard();

        final state = snapshot.data!;
        final feed = state.actions.feed;
        return DirectionY(
          children: [
            if (feed.hasComment) _CommentedView(state, feed.pid),

            HeaderSection(state),
            ContentSection(feed),

            if (feed.hasQuote) ...[
              QuotedContext(feed, start: 12, end: 8),
              const SizedBox(height: 4),
            ],

            FooterSection(state.actions, created: feed.createdAt),
          ],
        );
      },
    );
  }
}

class _CommentedView extends StatelessWidget {
  final StateView _state;
  final String _pid;
  const _CommentedView(this._state, this._pid);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: pctrl.loadFeed(_pid),
      builder: (_, snapshot) => snapshot.hasData
          ? CommentedContext(
              _state,
              snapshot.data!,
              hasActions: false,
              end: 388,
            )
          : const SizedBox.shrink(),
    );
  }
}
