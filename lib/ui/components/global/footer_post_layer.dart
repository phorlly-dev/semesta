import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:semesta/app/functions/option_modal.dart';
import 'package:semesta/app/routes/routes.dart';
import 'package:semesta/core/controllers/post_controller.dart';
import 'package:semesta/core/models/post_model.dart';
import 'package:semesta/ui/widgets/action_button.dart';

class FooterPostLayer extends StatelessWidget {
  final PostModel post;
  const FooterPostLayer({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    final routes = Routes();
    final options = OptionModal(context);
    final color = Theme.of(context).hintColor;
    final controller = Get.find<PostController>();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Obx(() {
        final model = controller.dataMapping[post.id];
        if (model == null) return const SizedBox();

        final curId = controller.currentId;
        final isLiked = model.isLiked(curId);
        final isSaved = model.isSaved(curId);
        final isReposted = model.isReposted(curId);

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
                  label: model.reliedCount,
                  iconColor: color,
                  onPressed: () async {
                    await context.pushNamed(
                      routes.replyPost.name,
                      pathParameters: {'id': model.id},
                    );
                  },
                ),

                // Like
                ActionButton(
                  icon: isLiked ? Icons.favorite : Icons.favorite_border,
                  label: model.likedCount,
                  isActive: isLiked,
                  iconColor: isLiked ? Colors.redAccent : color,
                  onPressed: () async {
                    await controller.toggleLike(model.id, isLiked);
                  },
                ),

                // Repost
                ActionButton(
                  icon: Icons.autorenew_rounded,
                  label: model.repostedCount,
                  iconColor: isReposted ? Colors.green : color,
                  isActive: isReposted,
                  onPressed: () {
                    options.repostOptions(model.id, isReposted);
                  },
                ),

                // Views
                ActionButton(
                  icon: Icons.remove_red_eye_outlined,
                  label: model.viewedCount,
                  iconColor: color,
                  onPressed: () {},
                ),
              ],
            ),

            // --- Right group: secondary actions ---
            Wrap(
              children: [
                ActionButton(
                  icon: isSaved
                      ? Icons.bookmark
                      : Icons.bookmark_border_rounded,
                  iconColor: isSaved ? Colors.blueAccent : color,
                  label: model.savedCount,
                  isActive: isSaved,
                  onPressed: () async {
                    await controller.toggleSave(model.id, isSaved);
                  },
                ),

                // Share
                ActionButton(
                  icon: Icons.ios_share_rounded,
                  iconColor: color,
                  label: model.sharedCount,
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
