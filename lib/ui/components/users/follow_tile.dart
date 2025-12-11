import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:semesta/app/routes/routes.dart';
import 'package:semesta/core/controllers/post_controller.dart';
import 'package:semesta/core/models/user_model.dart';
import 'package:semesta/ui/components/users/user_info.dart';
import 'package:semesta/ui/widgets/avatar_animation.dart';
import 'package:semesta/ui/widgets/follow_button.dart';

class FollowTile extends StatelessWidget {
  final UserModel user;
  const FollowTile({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final postCtrl = Get.find<PostController>();
    final userCtrl = postCtrl.userCtrl;
    final currentId = postCtrl.currentId;

    return Obx(() {
      final viewer = userCtrl.dataMapping[currentId];
      final owner = userCtrl.dataMapping[user.id];

      if (viewer == null || owner == null) {
        return const SizedBox.shrink();
      }

      final isOwner = viewer.id == owner.id;

      final iFollowThem = viewer.isFollowing(owner.id);
      final theyFollowMe = owner.isFollowing(currentId);
      final state = resolveState(iFollowThem, theyFollowMe);

      return InkWell(
        onTap: () {
          context.pushNamed(
            Routes().profile.name,
            pathParameters: {'id': owner.id},
            queryParameters: {'self': isOwner.toString()},
          );
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          child: Column(
            children: [
              // -------------------------------
              // Another user follow you
              // -------------------------------
              if (theyFollowMe) FollowYou(),

              Row(
                spacing: 12,
                children: [
                  // -------------------------------
                  // Avatar
                  // -------------------------------
                  AvatarAnimation(imageUrl: user.avatar),

                  // -------------------------------
                  // User info (name, username, bio)
                  // -------------------------------
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        DisplayName(data: user.name),
                        Username(data: user.username),
                        if (user.bio.isNotEmpty) Bio(data: user.bio),
                      ],
                    ),
                  ),

                  // -------------------------------
                  // Follow button (reactive)
                  // -------------------------------
                  if (!isOwner)
                    FollowButton(
                      user: owner,
                      state: state,
                      onPressed: () async {
                        await postCtrl.toggleFollow(owner.id, iFollowThem);
                      },
                    ),
                ],
              ),
            ],
          ),
        ),
      );
    });
  }
}
