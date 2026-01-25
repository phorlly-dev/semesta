import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:semesta/public/extensions/extension.dart';
import 'package:semesta/public/helpers/generic_helper.dart';
import 'package:semesta/src/components/layout/_layout_page.dart';
import 'package:semesta/src/components/global/card_skeleton.dart';
import 'package:semesta/src/components/layout/custom_app_bar.dart';
import 'package:semesta/src/components/post/comments_list.dart';
import 'package:semesta/src/partials/post_detail_info.dart';
import 'package:semesta/src/widgets/sub/break_section.dart';

class PostDetailsPage extends StatelessWidget {
  final String _pid;
  const PostDetailsPage(this._pid, {super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutPage(
      header: CustomAppBar(middle: Text('Post Details')),
      content: Obx(() {
        final post = pctrl.dataMapping[_pid];
        if (post == null) return const CardSkeleton();

        return NestedScrollView(
          headerSliverBuilder: (_, innerBox) => [
            SliverPadding(
              padding: EdgeInsetsGeometry.only(bottom: 8),
              sliver: SliverToBoxAdapter(child: const BreakSection()),
            ),

            SliverToBoxAdapter(child: PostDetailInfo(post)),
          ],
          body: CommentsList(_pid, post.uid),
        );
      }),
      footer: Wrap(
        children: [
          const BreakSection(height: 0),
          ListTile(
            title: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              child: Text('Post your reply'),
            ),
            onTap: () async {
              await context.openById(route.comment, _pid);
            },
          ),
        ],
      ),
    );
  }
}
