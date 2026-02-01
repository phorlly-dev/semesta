import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:semesta/public/extensions/extension.dart';
import 'package:semesta/public/helpers/generic_helper.dart';
import 'package:semesta/src/components/global/animated_card.dart';
import 'package:semesta/src/components/layout/nested_scrollable.dart';
import 'package:semesta/src/components/layout/_page.dart';
import 'package:semesta/src/components/layout/nav_bar.dart';
import 'package:semesta/src/partials/comments_list.dart';
import 'package:semesta/src/partials/post_details.dart';
import 'package:semesta/src/widgets/main/option_button.dart';
import 'package:semesta/src/widgets/sub/break_section.dart';
import 'package:semesta/src/widgets/sub/direction_y.dart';

class PostDetailsPage extends StatelessWidget {
  final String _pid;
  const PostDetailsPage(this._pid, {super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final post = pctrl.dataMapping[_pid];
      if (post == null) return const AnimatedCard();

      return PageLayout(
        header: AppNavBar(middle: Text('Post details')),
        content: NestedScrollable(
          builder: (_) => [
            SliverPadding(
              padding: EdgeInsetsGeometry.only(bottom: 8),
              sliver: SliverToBoxAdapter(child: const BreakSection()),
            ),

            SliverToBoxAdapter(child: SyncPostDetails(post)),
          ],
          child: CommentsList(_pid),
        ),
        footer: DirectionY(
          mainAxisSize: MainAxisSize.min,
          children: [
            const BreakSection(height: 0),
            OptionButton(
              'Post your reply',
              icon: Icons.read_more,
              canPop: false,
              onTap: () async {
                await context.openById(route.comment, _pid);
              },
            ),
            const SizedBox(height: 8),
          ],
        ),
      );
    });
  }
}
