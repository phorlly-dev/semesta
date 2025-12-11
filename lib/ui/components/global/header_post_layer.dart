import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:semesta/app/functions/reply_option.dart';
import 'package:semesta/app/routes/routes.dart';
import 'package:semesta/core/controllers/post_controller.dart';
import 'package:semesta/core/models/post_model.dart';
import 'package:semesta/ui/components/users/user_info.dart';
import 'package:semesta/ui/widgets/animated.dart';
import 'package:semesta/ui/widgets/avatar_animation.dart';

class HeaderPostLayer extends StatelessWidget {
  final PostModel post;
  final Widget? action;
  const HeaderPostLayer({super.key, required this.post, this.action});

  @override
  Widget build(BuildContext context) {
    final routes = Routes();
    final icon = ReplyOption(context).mapToIcon(post.visibility);
    final controller = Get.find<PostController>();
    final isOwner = controller.isCurrentUser(post.userId);

    return Padding(
      padding: const EdgeInsets.only(left: 16, top: 12, bottom: 10),
      child: Row(
        spacing: 12,
        children: [
          // -------------------------------
          // Avatar
          // -------------------------------
          AvatarAnimation(
            imageUrl: post.userAvatar,
            onTap: () async {
              await context.pushNamed(
                routes.profile.name,
                pathParameters: {'id': post.userId},
                queryParameters: {'self': isOwner.toString()},
              );
            },
          ),

          // -------------------------------
          // User info (name, username, status)
          // -------------------------------
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Animated(
                  onTap: () async {
                    await context.pushNamed(
                      routes.profile.name,
                      pathParameters: {'id': post.userId},
                      queryParameters: {'self': isOwner.toString()},
                    );
                  },
                  child: Wrap(
                    spacing: 3.2,
                    children: [
                      DisplayName(data: post.displayName),
                      Username(data: post.username),
                    ],
                  ),
                ),
                SizedBox(height: 4),
                Status(icon: icon, created: post.createdAt),
              ],
            ),
          ),

          ?action,
        ],
      ),
    );
  }
}
