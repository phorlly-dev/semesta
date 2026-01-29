import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:semesta/public/extensions/extension.dart';
import 'package:semesta/public/helpers/feed_view.dart';
import 'package:semesta/public/helpers/generic_helper.dart';
import 'package:semesta/public/helpers/utils_helper.dart';
import 'package:semesta/public/utils/custom_modal.dart';
import 'package:semesta/src/components/info/reposted_banner.dart';
import 'package:semesta/src/components/user/user_info.dart';
import 'package:semesta/src/widgets/main/follow_button.dart';
import 'package:semesta/src/widgets/sub/avatar_animation.dart';
import 'package:semesta/src/widgets/sub/direction_x.dart';
import 'package:semesta/src/widgets/sub/direction_y.dart';

class HeaderSection extends StatelessWidget {
  final StateView _state;
  const HeaderSection(this._state, {super.key});

  @override
  Widget build(BuildContext context) {
    final status = _state.status;
    final authed = status.authed;
    final iFollow = status.iFollow;

    final user = status.author;
    final actions = _state.actions;
    final model = actions.feed;

    return DirectionY(
      children: [
        RepostedBanner(actions.target),

        AnimatedBuilder(
          animation: status,
          builder: (_, child) => DirectionX(
            padding: const EdgeInsets.only(left: 12, bottom: 4),
            children: [
              AvatarAnimation(
                user.avatar,
                padding: const EdgeInsets.only(top: 6.0),
                onTap: () async {
                  await context.openProfile(user.id, authed);
                },
              ),
              const SizedBox(width: 8),

              Expanded(
                child: DirectionY(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    DirectionX(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        DisplayName(user.name),
                        if (user.verified) ...[
                          SizedBox(width: 6),
                          Icon(
                            Icons.verified,
                            size: 14,
                            color: context.primaryColor,
                          ),
                        ],
                      ],
                    ),

                    Username(user.uname),
                  ],
                ),
              ),

              DirectionX(
                padding: const EdgeInsets.only(right: 6.0),
                crossAxisAlignment: CrossAxisAlignment.center,
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
                              status.toggle();
                              context.pop();
                              await actrl.toggleFollow(user.id, iFollow);
                            },
                            label: 'Unfollow',
                            icon: Icons.person_remove_sharp,
                            color: context.primaryColor,
                          );
                        } else {
                          status.toggle();
                          await actrl.toggleFollow(user.id, iFollow);
                        }
                      },
                    ),

                  InkWell(
                    borderRadius: BorderRadius.circular(20),
                    child: Icon(
                      Icons.more_vert_outlined,
                      size: 20,
                      color: context.secondaryColor,
                    ),
                    onTap: () {
                      if (authed) {
                        context.open.currentOptions(
                          model,
                          actions.target,
                          active: actions.bookmarked,
                          profiled: false,
                        );
                      } else {
                        context.open.anotherOptions(
                          model,
                          actions.target,
                          status: status,
                          profiled: false,
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
      ],
    );
  }
}
