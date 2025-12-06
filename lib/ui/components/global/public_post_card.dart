import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:semesta/app/functions/option_modal.dart';
import 'package:semesta/app/functions/reply_option.dart';
import 'package:semesta/app/routes/routes.dart';
import 'package:semesta/core/controllers/action_controller.dart';
import 'package:semesta/core/models/post_model.dart';
import 'package:semesta/ui/components/global/_layout_card.dart';
import 'package:semesta/ui/components/global/content_post_layer.dart';
import 'package:semesta/ui/components/global/footer_post_layer.dart';
import 'package:semesta/ui/components/global/header_post_layer.dart';
import 'package:semesta/ui/widgets/group_button.dart';

class PublicPostCard extends StatelessWidget {
  final PostModel post;
  const PublicPostCard({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    final routes = Routes();
    final options = OptionModal(context);
    final controller = Get.find<ActionController>();

    Future.microtask(() => controller.listenToPost(post.id));

    final userCtrl = controller.userCtrl;
    final icon = ReplyOption(context).mapToIcon(post.visibility);
    final isOwner = userCtrl.isCurrentUser(post.userId).obs;
    final isFollow = controller.currentUser?.isFollowing(post.userId);

    return Obx(() {
      final pstAc = controller.postsMap[post.id]?.value ?? post;
      final currentUser = controller.currentUser!;
      final uid = currentUser.id;

      final isLiked = pstAc.isLiked(uid);
      final isSaved = pstAc.isSaved(uid);
      final isReposted = pstAc.isReposted(uid);

      isOwner.value = userCtrl.isCurrentUser(post.userId);
      isFollow!.value = currentUser.isFollowing(post.userId).value;

      return LayoutCard(
        isCompact: true,
        header: HeaderPostLayer(
          name: post.displayName,
          username: post.username,
          avatar: post.userAvatar,
          created: post.createdAt,
          visibility: icon,
          onProfile: () async {
            await context.pushNamed(
              routes.profile.name,
              pathParameters: {'id': post.userId},
              queryParameters: {'parent': post.id},
            );
          },
          action: GroupButton(
            isOwner: isOwner.value,
            initialFollow: isFollow.value,
            onOptions: isOwner.value
                ? null
                : () => options.unfollow(post.userId, post.username),
            onFollow: () async {
              await controller.toggleFollow(post.userId, isFollow.value);
              isFollow.toggle();

              // add smooth delay for “Following” → “•••” transition
              await Future.delayed(const Duration(milliseconds: 600));
              isFollow.value = currentUser.isFollowing(post.userId).value;
            },
          ),
        ),
        content: ContentPostLayer(
          title: post.content,
          id: post.id,
          media: post.media,
        ),
        footer: FooterPostLayer(
          isLiked: isLiked.value,
          valLike: pstAc.likedCount,
          onLike: () async {
            await controller.toggleLike(pstAc.id, isLiked.value);
            isLiked.toggle();
          },

          valReply: pstAc.reliedCount,
          onReply: () async {
            await context.pushNamed(
              routes.replyPost.name,
              pathParameters: {'id': post.id},
            );
          },

          isReposted: isReposted.value,
          valRepost: pstAc.repostedCount,
          onRepost: () {
            options.repostOptions(post.id, isReposted.value);
            isReposted.toggle();
          },

          isSaved: isSaved.value,
          valSave: pstAc.savedCount,
          onSave: () {
            controller.toggleSave(post.id, isSaved.value);
            isSaved.toggle();
          },

          valShare: pstAc.sharedCount,
          onShare: () {},

          valview: pstAc.viewedCount,
          onView: () {},
        ),
      );
    });
  }
}
