import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:semesta/app/extensions/controller_extension.dart';
import 'package:semesta/app/functions/custom_modal.dart';
import 'package:semesta/app/routes/routes.dart';
import 'package:semesta/core/controllers/action_controller.dart';
import 'package:semesta/core/views/audit_view.dart';
import 'package:semesta/ui/components/users/user_info.dart';
import 'package:semesta/ui/widgets/animated.dart';
import 'package:semesta/ui/widgets/avatar_animation.dart';
import 'package:semesta/ui/widgets/break_section.dart';
import 'package:semesta/ui/widgets/follow_button.dart';
import 'package:semesta/ui/components/layouts/loading_skelenton.dart';

const unfollow =
    'Their posts will no longer show up in your home timeline. You can still view their profile, unless their posts are proteted.';

class FollowTile extends StatelessWidget {
  final String uid;
  const FollowTile({super.key, required this.uid});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final ctrl = Get.find<ActionController>();
    return StreamBuilder<StatusView>(
      stream: ctrl.statusStream$(uid),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const LoadingSkelenton();

        final ctx = snapshot.data!;
        final author = ctx.author;
        return Animated(
          onTap: () async {
            await context.pushNamed(
              Routes().profile.name,
              pathParameters: {'id': author.id},
              queryParameters: {'self': ctx.authed.toString()},
            );
          },
          child: Column(
            children: [
              SizedBox(height: 4),

              // -------------------------------
              // Another author follow you
              // -------------------------------
              if (ctx.theyFollow) FollowYou(),

              Padding(
                padding: const EdgeInsetsDirectional.only(
                  start: 12,
                  end: 8,
                  bottom: 8,
                ),
                child: Row(
                  spacing: 12,
                  children: [
                    // -------------------------------
                    // Avatar
                    // -------------------------------
                    AvatarAnimation(imageUrl: author.avatar),

                    // -------------------------------
                    // author info (name, authorname, bio)
                    // -------------------------------
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          DisplayName(data: author.name, maxChars: 56),
                          Username(data: author.uname, maxChars: 56),
                          if (author.bio.isNotEmpty) Bio(data: author.bio),
                        ],
                      ),
                    ),

                    // -------------------------------
                    // Follow button (reactive)
                    // -------------------------------
                    if (!ctx.authed)
                      FollowButton(
                        state: resolveState(ctx.iFollow, ctx.theyFollow),
                        onPressed: () async {
                          !ctx.iFollow
                              ? await ctrl.toggleFollow(author.id, ctx.iFollow)
                              : CustomModal(
                                  context,
                                  title: 'Unfollow ${author.name}?',
                                  children: [Text(unfollow)],
                                  onConfirm: () async {
                                    context.pop();
                                    await ctrl.toggleFollow(
                                      author.id,
                                      ctx.iFollow,
                                    );
                                  },
                                  label: 'Unfollow',
                                  icon: Icons.person_remove_sharp,
                                  color: colors.primary,
                                );
                        },
                      ),
                  ],
                ),
              ),

              BreakSection(),
            ],
          ),
        );
      },
    );
  }
}
