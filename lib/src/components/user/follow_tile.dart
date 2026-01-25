import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:semesta/public/extensions/controller_extension.dart';
import 'package:semesta/public/extensions/extension.dart';
import 'package:semesta/public/helpers/audit_view.dart';
import 'package:semesta/public/helpers/generic_helper.dart';
import 'package:semesta/public/helpers/utils_helper.dart';
import 'package:semesta/public/utils/custom_modal.dart';
import 'package:semesta/src/components/global/loading_skelenton.dart';
import 'package:semesta/src/components/user/user_info.dart';
import 'package:semesta/src/widgets/sub/avatar_animation.dart';
import 'package:semesta/src/widgets/sub/break_section.dart';
import 'package:semesta/src/widgets/main/follow_button.dart';

class FollowTile extends StatelessWidget {
  final String _uid;
  const FollowTile(this._uid, {super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return StreamBuilder<StatusView>(
      stream: actrl.statusStream$(_uid),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const LoadingSkelenton();

        final ctx = snapshot.data!;
        final author = ctx.author;

        return AnimatedBuilder(
          animation: ctx,
          builder: (context, child) {
            return InkWell(
              onTap: () async {
                await context.openProfile(author.id, ctx.authed);
              },
              child: Column(
                children: [
                  SizedBox(height: 4),

                  // -------------------------------
                  // Another author follow you
                  // -------------------------------
                  if (ctx.theyFollow) FollowYouBanner(),

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
                        AvatarAnimation(author.avatar),

                        // -------------------------------
                        // author info (name, authorname, bio)
                        // -------------------------------
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              DisplayName(author.name, maxChars: 50),
                              Username(author.uname, maxChars: 56),
                              if (author.bio.isNotEmpty) ...[
                                SizedBox(height: 6),
                                Bio(author.bio),
                              ],
                            ],
                          ),
                        ),

                        // -------------------------------
                        // Follow button (reactive)
                        // -------------------------------
                        if (!ctx.authed)
                          FollowButton(
                            resolveState(ctx.iFollow, ctx.theyFollow),
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

                  const BreakSection(),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
