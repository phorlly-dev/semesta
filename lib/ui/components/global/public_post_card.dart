import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:semesta/app/functions/option_modal.dart';
import 'package:semesta/core/controllers/post_controller.dart';
import 'package:semesta/core/models/post_model.dart';
import 'package:semesta/ui/components/global/_layout_card.dart';
import 'package:semesta/ui/components/global/content_post_layer.dart';
import 'package:semesta/ui/components/global/footer_post_layer.dart';
import 'package:semesta/ui/components/global/header_post_layer.dart';
import 'package:semesta/ui/widgets/follow_button.dart';

class PublicPostCard extends StatelessWidget {
  final PostModel post;
  final Widget? top;

  const PublicPostCard({super.key, required this.post, this.top});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PostController>();
    final userCtrl = controller.userCtrl;
    final curId = controller.currentId;
    final options = OptionModal(context);

    return LayoutCard(
      isCompact: true,
      top: top,
      header: HeaderPostLayer(
        post: post,
        action: Obx(() {
          // Grab viewer + owner safely
          final viewer = userCtrl.dataMapping[curId];
          final owner = userCtrl.dataMapping[post.userId];
          final model = controller.dataMapping[post.id];

          // If user states aren’t loaded yet → don’t break UI
          if (viewer == null || owner == null || model == null) {
            return const SizedBox.shrink();
          }

          final isOwner = viewer.id == owner.id;

          // Relationship logic
          final iFollowThem = viewer.isFollowing(owner.id);
          final theyFollowMe = owner.isFollowing(viewer.id);

          final isSaved = model.isSaved(curId);
          final followState = resolveState(iFollowThem, theyFollowMe);

          return Row(
            children: [
              // Show follow button only when viewing someone else
              if (!isOwner)
                FollowButton(
                  user: owner,
                  state: followState,
                  onPressed: () async {
                    // Toggle between Follow / Unfollow
                    await controller.toggleFollow(owner.id, iFollowThem);
                  },
                ),

              IconButton(
                icon: const Icon(Icons.more_vert_outlined),
                onPressed: () {
                  if (isOwner) {
                    options.currentOptions(
                      model.id,
                      post.userId,
                      isSaved: isSaved,
                      option: model.visibility,
                    );
                  } else {
                    options.anotherOptions(
                      owner,
                      model.id,
                      isFollowing: iFollowThem,
                      isSaved: isSaved,
                    );
                  }
                },
              ),
            ],
          );
        }),
      ),

      content: ContentPostLayer(
        title: post.content,
        id: post.id,
        media: post.media,
      ),

      footer: FooterPostLayer(post: post),
    );
  }
}
