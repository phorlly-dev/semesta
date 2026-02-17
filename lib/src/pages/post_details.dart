import 'package:flutter/material.dart';
import 'package:semesta/public/extensions/context_extension.dart';
import 'package:semesta/public/helpers/generic_helper.dart';
import 'package:semesta/src/components/global/animated_card.dart';
import 'package:semesta/src/components/layout/nested_scrollable.dart';
import 'package:semesta/src/components/layout/_page.dart';
import 'package:semesta/src/components/layout/nav_bar.dart';
import 'package:semesta/src/partials/comments_list.dart';
import 'package:semesta/src/partials/post_detail.dart';
import 'package:semesta/src/widgets/main/option_button.dart';
import 'package:semesta/src/widgets/sub/break_section.dart';
import 'package:semesta/src/widgets/sub/direction_y.dart';

class PostDetailsPage extends StatelessWidget {
  final String _pid;
  const PostDetailsPage(this._pid, {super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: pctrl.loadFeed(_pid),
      builder: (_, snapshot) {
        if (!snapshot.hasData) return const AnimatedCard();

        return PageLayout(
          header: AppNavBar(middle: Text('Post details')),
          content: NestedScrollable(
            builder: (_) => [
              SliverPadding(
                padding: EdgeInsetsGeometry.only(bottom: 8),
                sliver: SliverToBoxAdapter(child: const BreakSection()),
              ),

              SliverToBoxAdapter(child: SyncPostDetail(snapshot.data!)),
            ],
            child: CommentsList(_pid),
          ),
          footer: DirectionY(
            size: MainAxisSize.min,
            children: [
              const BreakSection(height: 0),
              OptionButton(
                'Post your reply',
                icon: Icons.read_more,
                canPop: false,
                onTap: () async {
                  await context.openById(routes.comment, _pid);
                },
              ),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }
}
