import 'package:flutter/material.dart';
import 'package:get/get.dart';
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

class SyncPostDetails extends StatelessWidget {
  final Feed _post;
  const SyncPostDetails(this._post, {super.key});

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
              _QuotedView(feed),
              const SizedBox(height: 4),
            ],
            FooterSection(state.actions, created: feed.createdAt),
          ],
        );
      },
    );
  }
}

class _QuotedView extends StatelessWidget {
  final Feed _parent;
  const _QuotedView(this._parent);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final parent = pctrl.dataMapping[_parent.pid];
      final actor = uctrl.dataMapping[parent?.uid ?? _parent.uid];

      return parent == null || actor == null
          ? const SizedBox.shrink()
          : QuotedContext(quoted: parent, actor: actor, start: 12, end: 8);
    });
  }
}

class _CommentedView extends StatelessWidget {
  final StateView _state;
  final String _pid;
  const _CommentedView(this._state, this._pid);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final parent = pctrl.dataMapping[_pid];

      return parent == null
          ? const SizedBox.shrink()
          : CommentedContext(
              _state,
              parent: parent,
              hasActions: false,
              ededLine: 388,
            );
    });
  }
}
