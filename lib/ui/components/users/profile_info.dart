import 'package:flutter/material.dart';
import 'package:semesta/app/utils/extension.dart';
import 'package:semesta/core/models/user_model.dart';
import 'package:semesta/ui/widgets/action_button.dart';
import 'package:semesta/ui/widgets/action_count.dart';
import 'package:semesta/ui/widgets/avatar_animation.dart';
import 'package:semesta/ui/widgets/custom_text_button.dart';

class ProfileInfo extends StatelessWidget {
  final UserModel user;
  final bool isOwner, isFollow;
  final VoidCallback? onFollow, onPreview, onEdit;

  const ProfileInfo({
    super.key,
    required this.user,
    required this.isOwner,
    this.isFollow = false,
    this.onFollow,
    this.onPreview,
    this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final text = theme.textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          title: Text(
            user.name,
            style: text.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          subtitle: Text(
            '@${user.username}',
            style: text.titleSmall?.copyWith(color: colors.outline),
          ),
          leading: AvatarAnimation(
            imageUrl: user.avatar,
            size: 46,
            onTap: onPreview,
          ),
          trailing: isOwner
              ? CustomTextButton(
                  label: 'Edit Profile',
                  onPressed: onEdit,
                  bgColor: colors.secondary,
                  textColor: Colors.white,
                )
              : CustomTextButton(
                  label: isFollow ? 'Following' : "Folllow",
                  onPressed: onFollow,
                  bgColor: isFollow ? colors.primaryFixedDim : colors.scrim,
                  textColor: Colors.white,
                ),
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
                    ),
                    ActionCount(
                      label: 'followers',
                      value: user.followeredCount,
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
