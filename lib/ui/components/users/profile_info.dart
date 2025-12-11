import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:semesta/app/routes/routes.dart';
import 'package:semesta/app/utils/extension.dart';
import 'package:semesta/core/models/user_model.dart';
import 'package:semesta/ui/components/users/user_info.dart';
import 'package:semesta/ui/widgets/action_button.dart';
import 'package:semesta/ui/widgets/action_count.dart';
import 'package:semesta/ui/widgets/avatar_animation.dart';

class ProfileInfo extends StatelessWidget {
  final UserModel user;
  final Widget action;
  final VoidCallback? onPreview;
  const ProfileInfo({
    super.key,
    required this.user,
    required this.action,
    this.onPreview,
  });

  @override
  Widget build(BuildContext context) {
    final route = Routes();
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          leading: AvatarAnimation(
            imageUrl: user.avatar,
            size: 46,
            onTap: onPreview,
          ),
          title: DisplayName(data: user.name),
          subtitle: Username(data: user.username),
          trailing: action,
        ),

        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            spacing: 6,
            children: [
              Row(
                children: [
                  ActionButton(
                    sizeIcon: 20,
                    iconColor: colors.outline,
                    icon: Icons.batch_prediction_rounded,
                    label: 'Born ${user.dob!.toDate}',
                  ),

                  ActionButton(
                    sizeIcon: 20,
                    iconColor: colors.outline,
                    icon: Icons.calendar_month_outlined,
                    label: 'Joined on ${user.createdAt!.format('MMM yyyy')}',
                  ),
                ],
              ),

              Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Row(
                  spacing: 12,
                  children: [
                    ActionCount(
                      label: 'following',
                      value: user.followingedCount,
                      onTap: () async {
                        await context.pushNamed(
                          route.friendship.name,
                          pathParameters: {'id': user.id},
                          queryParameters: {'name': user.name, 'index': '1'},
                        );
                      },
                    ),
                    ActionCount(
                      label: 'followers',
                      value: user.followeredCount,
                      onTap: () async {
                        await context.pushNamed(
                          route.friendship.name,
                          pathParameters: {'id': user.id},
                          queryParameters: {'name': user.name, 'index': '0'},
                        );
                      },
                    ),
                    ActionCount(label: 'posts', value: user.postedCount),
                  ],
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 12),
      ],
    );
  }
}
