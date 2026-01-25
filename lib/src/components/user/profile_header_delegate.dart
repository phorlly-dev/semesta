import 'package:flutter/material.dart';
import 'package:semesta/public/extensions/extension.dart';
import 'package:semesta/src/widgets/main/custom_image.dart';
import 'package:semesta/src/widgets/sub/avatar_animation.dart';

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
              ? CustomImage(coverUrl)
              : Image.asset('bg-cover.jpg'.asImage(), fit: BoxFit.cover),
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
          child: AvatarAnimation(avatarUrl, size: avatarSize, onTap: onPreview),
        ),
      ],
    );
  }

  @override
  bool shouldRebuild(covariant ProfileHeaderDelegate oldDelegate) => true;
}
