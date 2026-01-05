import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:semesta/app/routes/routes.dart';
import 'package:semesta/app/extensions/extension.dart';
import 'package:semesta/app/utils/params.dart';
import 'package:semesta/core/models/author.dart';
import 'package:semesta/ui/components/users/user_info.dart';
import 'package:semesta/ui/widgets/action_button.dart';
import 'package:semesta/ui/widgets/action_count.dart';
import 'package:semesta/ui/widgets/avatar_animation.dart';

class ProfileInfo extends StatelessWidget {
  final Author user;
  final Widget action;
  final CountState state;
  final VoidCallback? onPreview;
  const ProfileInfo({
    super.key,
    required this.user,
    required this.action,
    this.onPreview,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    final route = Routes();
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Padding(
      padding: const EdgeInsetsDirectional.only(start: 12, end: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              AvatarAnimation(
                imageUrl: user.avatar,
                size: 52,
                onTap: onPreview,
              ),

              Spacer(),
              action,
            ],
          ),
          SizedBox(height: 8),

          DisplayName(data: user.name, maxChars: 50),
          Username(data: user.uname, maxChars: 60),
          SizedBox(height: 8),

          if (user.bio.isNotEmpty) Bio(data: user.bio),
          SizedBox(height: 8),

          Row(
            spacing: 6,
            children: [
              ActionButton(
                sizeIcon: 18,
                textSize: 14,
                iconColor: colors.outline,
                icon: Icons.batch_prediction_rounded,
                label: 'Born ${user.dob!.toDate}',
              ),

              ActionButton(
                sizeIcon: 18,
                textSize: 14,
                iconColor: colors.outline,
                icon: Icons.calendar_month_outlined,
                label: 'Joined on ${user.createdAt!.format('MMM yyyy')}',
              ),
            ],
          ),

          SizedBox(height: 8),
          Row(
            spacing: 12,
            children: [
              ActionCount(
                label: 'following',
                value: user.followingCount,
                onTap: () async {
                  await context.pushNamed(
                    route.friendship.name,
                    pathParameters: {'id': user.id},
                    queryParameters: {'name': user.name, 'index': '1'},
                  );
                },
              ),
              ActionCount(
                label: user.followersCount == 1 ? 'follower' : 'followers',
                value: user.followersCount,
                onTap: () async {
                  await context.pushNamed(
                    route.friendship.name,
                    pathParameters: {'id': user.id},
                    queryParameters: {'name': user.name, 'index': '0'},
                  );
                },
              ),
              ActionCount(label: state.key, value: state.value),
            ],
          ),
        ],
      ),
    );
  }
}
