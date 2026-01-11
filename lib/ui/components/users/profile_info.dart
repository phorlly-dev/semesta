import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:semesta/app/functions/format_helper.dart';
import 'package:semesta/app/extensions/extension.dart';
import 'package:semesta/core/views/generic_helper.dart';
import 'package:semesta/app/utils/params.dart';
import 'package:semesta/core/models/author.dart';
import 'package:semesta/ui/components/users/user_info.dart';
import 'package:semesta/ui/widgets/action_button.dart';
import 'package:semesta/ui/widgets/action_count.dart';
import 'package:semesta/ui/widgets/avatar_animation.dart';
import 'package:semesta/ui/widgets/custom_image.dart';

class ProfileInfo extends StatelessWidget {
  final Author user;
  final Widget action;
  final CountState state;
  const ProfileInfo({
    super.key,
    required this.user,
    required this.action,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        // White background for content
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 32, 12, 8),
          child: _AuthorInfo(user, state),
        ),

        // Edit / Follow button
        Positioned(right: 8, child: action),
      ],
    );
  }
}

class _AuthorInfo extends StatelessWidget {
  final Author user;
  final CountState state;
  const _AuthorInfo(this.user, this.state);

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DisplayName(data: user.name, maxChars: 50),
        Username(data: user.uname, maxChars: 60),
        SizedBox(height: 12),

        if (user.bio.isNotEmpty) Bio(data: user.bio),
        SizedBox(height: user.bio.isEmpty ? 0 : 6),

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

        SizedBox(height: 6),
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
    );
  }
}

class ProfileHeaderDelegate extends SliverPersistentHeaderDelegate {
  final double expandedHeight;
  final double collapsedHeight;
  final String avatarUrl;
  final String coverUrl;
  final bool authed;
  final VoidCallback? onPreview, onSettings, onFind;

  const ProfileHeaderDelegate({
    required this.expandedHeight,
    required this.collapsedHeight,
    required this.avatarUrl,
    required this.coverUrl,
    this.authed = false,
    this.onPreview,
    this.onSettings,
    this.onFind,
  });

  @override
  double get maxExtent => expandedHeight;

  @override
  double get minExtent => collapsedHeight;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    final pTop = MediaQuery.of(context).padding.top;
    final progress = (shrinkOffset / (maxExtent - minExtent)).clamp(0.0, 1.0);

    // Avatar sizes (X-like)
    final double avatarMax = 72;
    final double avatarMin = 36;
    final double avatarSize = avatarMax - (avatarMax - avatarMin) * progress;

    // Vertical movement
    final double avatarStartY = maxExtent - avatarMax / 2 - 16;
    final double avatarEndY = pTop + (kToolbarHeight - avatarMin) / 2;

    final double avatarY =
        avatarStartY - (avatarStartY - avatarEndY) * progress;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        // Cover image
        Positioned.fill(
          child: coverUrl.isNotEmpty
              ? CustomImage(image: coverUrl)
              : Image.asset(setImage('bg-cover.jpg'), fit: BoxFit.cover),
        ),

        // Dark overlay (optional, X-like)
        Positioned.fill(
          child: Container(
            color: Colors.black.withValues(alpha: 0.15 * progress),
          ),
        ),

        // Avatar
        Positioned(
          left: 16,
          top: avatarY,
          child: AvatarAnimation(
            imageUrl: avatarUrl,
            size: avatarSize,
            onTap: onPreview,
          ),
        ),
      ],
    );
  }

  @override
  bool shouldRebuild(covariant ProfileHeaderDelegate oldDelegate) => true;
}
