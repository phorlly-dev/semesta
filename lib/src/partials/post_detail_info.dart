import 'package:flutter/material.dart';
import 'package:semesta/public/extensions/controller_extension.dart';
import 'package:semesta/app/models/feed.dart';
import 'package:semesta/public/helpers/feed_view.dart';
import 'package:semesta/public/helpers/generic_helper.dart';
import 'package:semesta/src/components/global/loading_skelenton.dart';
import 'package:semesta/src/components/post/content_section.dart';
import 'package:semesta/src/components/post/footer_section.dart';
import 'package:semesta/src/components/post/header_section.dart';

class PostDetailInfo extends StatelessWidget {
  final Feed _post;
  const PostDetailInfo(this._post, {super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<StateView>(
      stream: actrl.stateSteam$(_post),
      builder: (_, snapshot) {
        if (!snapshot.hasData) return const LoadingSkelenton();

        final state = snapshot.data!;
        final feed = state.actions.feed;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HeaderSection(state),
            ContentSection(feed),
            FooterSection(state.actions, created: feed.createdAt),
          ],
        );
      },
    );
  }
}
