import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:semesta/app/functions/option_modal.dart';
import 'package:semesta/core/controllers/post_controller.dart';
import 'package:semesta/core/models/post_model.dart';
import 'package:semesta/ui/components/global/_layout_card.dart';
import 'package:semesta/ui/components/global/content_post_layer.dart';
import 'package:semesta/ui/components/global/footer_post_layer.dart';
import 'package:semesta/ui/components/global/header_post_layer.dart';
import 'package:semesta/ui/widgets/follow_button.dart';

class PrivatePostCard extends StatelessWidget {
  final PostModel post;
  final Widget? top;
  const PrivatePostCard({super.key, required this.post, this.top});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PostController>();
    final userCtrl = controller.userCtrl;
    final options = OptionModal(context);

    return Obx(() {
      // Grab viewer + owner safely
      final currentId = controller.currentId;
      final viewer = userCtrl.dataMapping[currentId];
      final owner = userCtrl.dataMapping[post.userId];
      final model = controller.dataMapping[post.id];

      // If user states aren’t loaded yet → don’t break UI
      if (viewer == null || owner == null || model == null) {
        return const SizedBox();
      }

      final isOwner = viewer.id == owner.id;

      // Relationship logic
      final iFollowThem = viewer.isFollowing(owner.id);
      final theyFollowMe = owner.isFollowing(currentId);

      final isSaved = model.isSaved(currentId);
      final state = resolveState(iFollowThem, theyFollowMe);

      return LayoutCard(
        isCompact: true,
        top: top,
        header: HeaderPostLayer(
          post: post,
          action: Row(
            children: [
              if (!isOwner)
                FollowButton(
                  user: owner,
                  state: state,
                  onPressed: () async {
                    await controller.toggleFollow(owner.id, iFollowThem);
                  },
                ),

              IconButton(
                onPressed: () {
                  if (isOwner) {
                    options.currentOptions(
                      post.id,
                      owner.id,
                      isPrivate: true,
                      isSaved: isSaved,
                      option: post.visibility,
                    );
                  } else {
                    options.anotherOptions(
                      owner,
                      model.id,
                      isSaved: isSaved,
                      isFollowing: iFollowThem,
                    );
                  }
                },
                icon: const Icon(Icons.more_vert_outlined),
              ),
            ],
          ),
        ),
        content: ContentPostLayer(
          title: post.content,
          id: post.id,
          media: post.media,
        ),
        footer: FooterPostLayer(post: post),
      );
    });
  }
}
