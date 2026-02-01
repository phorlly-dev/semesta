import 'package:flutter/material.dart';
import 'package:semesta/app/models/author.dart';
import 'package:semesta/public/extensions/extension.dart';
import 'package:semesta/public/helpers/generic_helper.dart';
import 'package:semesta/public/utils/delegate.dart';
import 'package:semesta/public/utils/params.dart';
import 'package:semesta/src/widgets/main/custom_image.dart';
import 'package:semesta/src/widgets/sub/animated_avatar.dart';

class ProfileHeader extends StatelessWidget {
  final Author _user;
  final bool authed;
  final double expanded;
  final double collapsed;
  final bool pinned, floating;
  const ProfileHeader(
    this._user, {
    super.key,
    this.authed = false,
    this.expanded = 160,
    this.collapsed = kToolbarHeight,
    this.pinned = false,
    this.floating = false,
  });

  @override
  Widget build(BuildContext context) {
    return SliverPersistentHeader(
      pinned: pinned,
      floating: floating,
      delegate: Delegate(
        rebuild: true,
        min: collapsed,
        max: expanded,
        builder: (min, max, shrink) {
          final pTop = context.query.padding.top;
          final progress = (shrink / (max - min)).clamp(0.0, 1.0);

          // Avatar sizes (X-like)
          final double avatarMax = 72;
          final double avatarMin = 36;
          final double avatarSize =
              avatarMax - (avatarMax - avatarMin) * progress;

          // Vertical movement
          final double avatarStartY = max - avatarMax / 2 - 16;
          final double avatarEndY = pTop + (kToolbarHeight - avatarMin) / 2;

          final double avatarY =
              avatarStartY - (avatarStartY - avatarEndY) * progress;

          return Stack(
            clipBehavior: Clip.none,
            children: [
              // Cover image
              Positioned.fill(
                child: _user.banner.isNotEmpty
                    ? CustomImage(MediaSource.network(_user.banner))
                    : CustomImage(MediaSource.asset('bg-cover.jpg'.asImage())),
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
                  MediaSource.network(_user.avatar),
                  size: avatarSize,
                  onTap: () async {
                    await context.openById(route.avatar, _user.id);
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
