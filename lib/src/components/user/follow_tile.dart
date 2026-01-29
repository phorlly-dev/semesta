import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:semesta/public/extensions/controller_extension.dart';
import 'package:semesta/public/extensions/extension.dart';
import 'package:semesta/public/helpers/generic_helper.dart';
import 'package:semesta/public/helpers/utils_helper.dart';
import 'package:semesta/public/utils/custom_modal.dart';
import 'package:semesta/src/components/global/loading_skelenton.dart';
import 'package:semesta/src/components/user/user_info.dart';
import 'package:semesta/src/widgets/sub/avatar_animation.dart';
import 'package:semesta/src/widgets/sub/break_section.dart';
import 'package:semesta/src/widgets/main/follow_button.dart';
import 'package:semesta/src/widgets/sub/direction_x.dart';
import 'package:semesta/src/widgets/sub/direction_y.dart';

class FollowTile extends StatelessWidget {
  final String _uid;
  const FollowTile(this._uid, {super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: actrl.status$(_uid),
      builder: (_, snapshot) {
        if (!snapshot.hasData) return const LoadingSkelenton();

        final state = snapshot.data!;
        final author = state.author;

        return AnimatedBuilder(
          animation: state,
          builder: (_, child) => InkWell(
            child: DirectionY(
              children: [
                // -------------------------------
                // Another author follow you
                // -------------------------------
                if (state.theyFollow) FollowYouBanner(),

                DirectionX(
                  spacing: 12,
                  padding: const EdgeInsetsDirectional.fromSTEB(12, 0, 8, 8),
                  children: [
                    // -------------------------------
                    // Avatar
                    // -------------------------------
                    AvatarAnimation(
                      author.avatar,
                      padding: const EdgeInsetsDirectional.only(top: 6),
                    ),

                    // -------------------------------
                    // author info (name, authorname, bio)
                    // -------------------------------
                    Expanded(
                      child: DirectionY(
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
                    if (!state.authed)
                      FollowButton(
                        resolveState(state.iFollow, state.theyFollow),
                        onPressed: () async {
                          if (state.iFollow) {
                            CustomModal(
                              context,
                              title: 'Unfollow ${author.name}?',
                              children: [Text(unfollow)],
                              onConfirm: () async {
                                state.toggle();
                                context.pop();
                                await actrl.toggleFollow(
                                  author.id,
                                  state.iFollow,
                                );
                              },
                              label: 'Unfollow',
                              icon: Icons.person_remove_sharp,
                              color: context.primaryColor,
                            );
                          } else {
                            state.toggle();
                            await actrl.toggleFollow(author.id, state.iFollow);
                          }
                        },
                      ),
                  ],
                ),

                const BreakSection(),
              ],
            ),
            onTap: () async {
              await context.openProfile(author.id, state.authed);
            },
          ),
        );
      },
    );
  }
}
