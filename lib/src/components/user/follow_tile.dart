import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:semesta/public/extensions/context_extension.dart';
import 'package:semesta/public/extensions/controller_extension.dart';
import 'package:semesta/public/extensions/model_extension.dart';
import 'package:semesta/public/helpers/generic_helper.dart';
import 'package:semesta/public/helpers/params_helper.dart';
import 'package:semesta/src/components/global/animated_card.dart';
import 'package:semesta/src/components/info/data_helper.dart';
import 'package:semesta/src/widgets/sub/animated_avatar.dart';
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
        if (!snapshot.hasData) return const AnimatedCard();

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
                if (state.theyFollow) FollowBanner(),

                DirectionX(
                  spacing: 12,
                  padding: const EdgeInsetsDirectional.fromSTEB(12, 0, 8, 8),
                  children: [
                    // -------------------------------
                    // Avatar
                    // -------------------------------
                    AnimatedAvatar(
                      MediaSource.network(author.media.url),
                      padding: const EdgeInsetsDirectional.only(top: 6),
                    ),

                    // -------------------------------
                    // author info (name, authorname, bio)
                    // -------------------------------
                    Expanded(
                      child: DirectionY(
                        children: [
                          DisplayName(author.name, maxChars: 32),
                          Username(author.uname, maxChars: 50),
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
                        state.chekedFollow,
                        onPressed: () {
                          if (state.iFollow) {
                            context.dialog(
                              title: 'Unfollow ${author.name}?',
                              children: [Text(unfollow)],
                              onConfirm: () {
                                state.toggle();
                                context.pop();
                                actrl.toggleFollow(state);
                              },
                              label: 'Unfollow',
                              icon: Icons.person_remove_sharp,
                              color: context.primaryColor,
                            );
                          } else {
                            state.toggle();
                            actrl.toggleFollow(state);
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
