import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:semesta/app/extensions/controller_extension.dart';
import 'package:semesta/app/utils/custom_modal.dart';
import 'package:semesta/core/views/generic_helper.dart';
import 'package:semesta/core/views/audit_view.dart';
import 'package:semesta/core/views/utils_helper.dart';
import 'package:semesta/ui/components/users/user_info.dart';
import 'package:semesta/ui/widgets/avatar_animation.dart';
import 'package:semesta/ui/widgets/break_section.dart';
import 'package:semesta/ui/widgets/follow_button.dart';
import 'package:semesta/ui/components/layouts/loading_skelenton.dart';

class FollowTile extends StatelessWidget {
  final String uid;
  const FollowTile({super.key, required this.uid});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return StreamBuilder<StatusView>(
      stream: actrl.statusStream$(uid),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const LoadingSkelenton();

        final ctx = snapshot.data!;
        final author = ctx.author;

        return AnimatedBuilder(
          animation: ctx,
          builder: (context, child) {
            return InkWell(
              onTap: () async {
                await context.pushNamed(
                  route.profile.name,
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
                              DisplayName(data: author.name, maxChars: 50),
                              Username(data: author.uname, maxChars: 56),
                              if (author.bio.isNotEmpty) ...[
                                SizedBox(height: 6),
                                Bio(data: author.bio),
                              ],
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
                              if (ctx.iFollow) {
                                CustomModal(
                                  context,
                                  title: 'Unfollow ${author.name}?',
                                  children: [Text(unfollow)],
                                  onConfirm: () async {
                                    context.pop();
                                    ctx.toggle();
                                    await actrl.toggleFollow(
                                      author.id,
                                      ctx.iFollow,
                                    );
                                  },
                                  label: 'Unfollow',
                                  icon: Icons.person_remove_sharp,
                                  color: colors.primary,
                                );
                              } else {
                                ctx.toggle();
                                await actrl.toggleFollow(
                                  author.id,
                                  ctx.iFollow,
                                );
                              }
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
      },
    );
  }
}
