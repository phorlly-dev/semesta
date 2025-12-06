import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:semesta/app/functions/option_modal.dart';
import 'package:semesta/app/routes/routes.dart';
import 'package:semesta/core/controllers/action_controller.dart';
import 'package:semesta/ui/widgets/action_button.dart';

class PostFooter extends StatelessWidget {
  final String postId;
  const PostFooter({super.key, required this.postId});

  @override
  Widget build(BuildContext context) {
    final routes = Routes();
    final options = OptionModal(context);
    final color = Theme.of(context).hintColor;
    final controller = Get.find<ActionController>();

    Future.microtask(() => controller.listenToPost(postId));

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Obx(() {
        final post = controller.postsMap[postId]?.value;
        final curId = controller.currentUser!.id;

        if (post == null) return const SizedBox.shrink();

        // final isOwner = curId == post.userId;
        final isLiked = post.isLiked(curId);
        final isSaved = post.isSaved(curId);
        final isRepost = post.isReposted(curId);

        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // --- Left group: engagement actions ---
            Wrap(
              spacing: 3.2,
              children: [
                // Comment
                ActionButton(
                  icon: 'comment.png',
                  label: post.reliedCount,
                  iconColor: color,
                  onPressed: () {
                    context.pushNamed(
                      routes.replyPost.name,
                      pathParameters: {'id': post.id},
                    );
                  },
                ),

                // Like
                ActionButton(
                  icon: isLiked.value ? Icons.favorite : Icons.favorite_border,
                  label: post.likedCount,
                  iconColor: isLiked.value ? Colors.redAccent : color,
                  onPressed: () {
                    controller.toggleLike(post.id, isLiked.value);
                    isLiked.toggle();
                  },
                ),

                // Repost
                ActionButton(
                  icon: Icons.autorenew_rounded,
                  label: post.repostedCount,
                  iconColor: isRepost.value ? Colors.green : color,
                  onPressed: () {
                    options.repostOptions(post.id, isRepost.value);
                    isRepost.toggle();
                  },
                ),

                // Views
                ActionButton(
                  icon: Icons.remove_red_eye_outlined,
                  label: post.viewedCount,
                  iconColor: color,
                  onPressed: () {},
                ),
              ],
            ),

            // --- Right group: secondary actions ---
            Wrap(
              children: [
                ActionButton(
                  icon: isSaved.value
                      ? Icons.bookmark
                      : Icons.bookmark_border_rounded,
                  iconColor: isSaved.value ? Colors.blueAccent : color,
                  label: post.savedCount,
                  onPressed: () {
                    controller.toggleSave(post.id, isSaved.value);
                    isSaved.toggle();
                  },
                ),

                // Share
                ActionButton(
                  icon: Icons.ios_share_rounded,
                  iconColor: color,
                  label: post.sharedCount,
                  onPressed: () {},
                ),
              ],
            ),
            // Save
          ],
        );
      }),
    );
  }
}
