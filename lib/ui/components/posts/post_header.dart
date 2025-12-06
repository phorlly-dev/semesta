import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:semesta/app/functions/format.dart';
import 'package:semesta/app/functions/option_modal.dart';
import 'package:semesta/app/functions/reply_option.dart';
import 'package:semesta/core/controllers/post_controller.dart';
import 'package:semesta/core/controllers/user_controller.dart';
import 'package:semesta/core/models/post_model.dart';
import 'package:semesta/ui/widgets/animated.dart';
import 'package:semesta/ui/widgets/avatar_animation.dart';
import 'package:semesta/ui/widgets/group_button.dart';

class PostHeader extends StatelessWidget {
  final PostModel post;
  final bool verified, isProfile;
  final VoidCallback? onProfile, onDetails;

  const PostHeader({
    super.key,
    this.verified = false,
    this.onProfile,
    this.onDetails,
    required this.post,
    required this.isProfile,
  });

  @override
  Widget build(BuildContext context) {
    final option = OptionModal(context);
    final userCtrl = Get.find<UserController>();
    final postCtrl = Get.find<PostController>();
    final colors = Theme.of(context).colorScheme;

    final icon = ReplyOption(context).mapToIcon(post.visibility);
    final isOwner = userCtrl.isCurrentUser(post.userId).obs;
    final isFollow = postCtrl.currentUser?.isFollowing(post.userId);

    return ListTile(
      dense: true,
      onTap: onDetails,
      leading: AvatarAnimation(imageUrl: post.userAvatar, onTap: onProfile),
      title: Animated(
        onTap: onProfile,
        child: Row(
          spacing: 3.2,
          children: [
            Text(
              post.displayName,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            if (verified) Icon(Icons.verified, color: colors.primary, size: 15),
            Text(
              isOwner.value || isFollow!.value
                  ? '@${limitText(post.username, 24)}'
                  : '@${limitText(post.username)}',
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 14.8,
                fontWeight: FontWeight.w500,
                color: colors.secondary,
              ),
            ),
          ],
        ),
      ),
      subtitle: Row(
        spacing: 3.2,
        children: [
          Text(
            timeAgo(post.createdAt),
            style: TextStyle(fontSize: 13.6, color: colors.secondary),
          ),
          Icon(Icons.circle, size: 3.2, color: colors.secondary),
          Icon(icon, size: 12, color: colors.primary),
        ],
      ),
      trailing: Obx(() {
        isOwner.value = userCtrl.isCurrentUser(post.userId);
        isFollow!.value = postCtrl.currentUser!.isFollowing(post.userId).value;

        return GroupButton(
          isOwner: isOwner.value,
          initialFollow: isFollow.value,
          onOptions: () {
            if (isOwner.value) {
              option.postOptions(post.id, post.userId, option: post.visibility);
            } else {
              option.unfollow(post.userId, post.username);
            }
          },
          onFollow: () async {
            await userCtrl.toggleFollow(post.userId);
            await postCtrl.toggleFollow(post.userId, isFollow.value);

            // add smooth delay for “Following” → “•••” transition
            await Future.delayed(const Duration(milliseconds: 600));
            isFollow.value = postCtrl.currentUser!
                .isFollowing(post.userId)
                .value;
          },
        );
      }),
    );
  }
}
