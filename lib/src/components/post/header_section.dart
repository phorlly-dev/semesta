import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:semesta/public/extensions/extension.dart';
import 'package:semesta/public/functions/option_modal.dart';
import 'package:semesta/public/helpers/feed_view.dart';
import 'package:semesta/public/helpers/generic_helper.dart';
import 'package:semesta/public/helpers/utils_helper.dart';
import 'package:semesta/public/utils/custom_modal.dart';
import 'package:semesta/src/components/info/reposted_banner.dart';
import 'package:semesta/src/components/user/user_info.dart';
import 'package:semesta/src/widgets/main/follow_button.dart';
import 'package:semesta/src/widgets/sub/avatar_animation.dart';

class HeaderSection extends StatelessWidget {
  final StateView _state;
  const HeaderSection(this._state, {super.key});

  @override
  Widget build(BuildContext context) {
    final options = OptionModal(context);
    final colors = Theme.of(context).colorScheme;

    final status = _state.status;
    final authed = status.authed;
    final iFollow = status.iFollow;

    final user = status.author;
    final actions = _state.actions;
    final model = actions.feed;

    return Column(
      children: [
        RepostedBanner(actions.target),

        Padding(
          padding: const EdgeInsets.only(left: 12),
          child: AnimatedBuilder(
            animation: status,
            builder: (_, child) => Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AvatarAnimation(
                  user.avatar,
                  onTap: () async {
                    await context.openProfile(user.id, authed);
                  },
                ),
                const SizedBox(width: 8),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          DisplayName(user.name),
                          if (user.verified)
                            Padding(
                              padding: const EdgeInsets.only(left: 4),
                              child: Icon(
                                Icons.verified,
                                size: 14,
                                color: colors.primary,
                              ),
                            ),
                        ],
                      ),

                      Username(user.uname),
                    ],
                  ),
                ),

                Row(
                  children: [
                    if (!authed)
                      FollowButton(
                        resolveState(iFollow, status.theyFollow),
                        onPressed: () async {
                          if (iFollow) {
                            CustomModal(
                              context,
                              title: 'Unfollow ${user.name}?',
                              children: [Text(unfollow)],
                              onConfirm: () async {
                                context.pop();
                                status.toggle();
                                await actrl.toggleFollow(user.id, iFollow);
                              },
                              label: 'Unfollow',
                              icon: Icons.person_remove_sharp,
                              color: colors.primary,
                            );
                          } else {
                            status.toggle();
                            await actrl.toggleFollow(user.id, iFollow);
                          }
                        },
                      ),

                    InkWell(
                      borderRadius: BorderRadius.circular(20),
                      child: Padding(
                        padding: const EdgeInsets.all(4),
                        child: Icon(
                          Icons.more_vert_outlined,
                          size: 20,
                          color: colors.secondary,
                        ),
                      ),
                      onTap: () {
                        if (authed) {
                          options.currentOptions(
                            model,
                            actions.target,
                            active: actions.bookmarked,
                            primary: true,
                          );
                        } else {
                          options.anotherOptions(
                            model,
                            actions.target,
                            status: status,
                            primary: true,
                            name: user.name,
                            iFollow: iFollow,
                            active: actions.bookmarked,
                          );
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
