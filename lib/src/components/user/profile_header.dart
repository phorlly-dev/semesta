import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/context_extensions.dart';
import 'package:semesta/app/models/author.dart';
import 'package:semesta/public/extensions/context_extension.dart';
import 'package:semesta/public/extensions/string_extension.dart';
import 'package:semesta/public/helpers/generic_helper.dart';
import 'package:semesta/public/utils/delegate.dart';
import 'package:semesta/public/helpers/params_helper.dart';
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
          final ptop = context.mediaQuery.padding.top;
          final progress = (shrink / (max - min)).clamp(0.0, 1.0);

          // Avatar sizes (X-like)
          final amax = 72.0;
          final amin = 36.0;
          final asize = amax - (amax - amin) * progress;

          // Vertical movement
          final astartY = max - amax / 2 - 16;
          final avatarEndY = ptop + (kToolbarHeight - amin) / 2;
          final avatarY = astartY - (astartY - avatarEndY) * progress;

          final cover = _user.media.others;
          return Stack(
            clipBehavior: Clip.none,
            children: [
              // Cover image
              Positioned.fill(
                child: CustomImage(
                  cover.isNotEmpty
                      ? MediaSource.network(cover[0])
                      : MediaSource.asset('bg-cover.jpg'.toAsset()),
                ),
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
                child: AnimatedAvatar(
                  MediaSource.network(_user.media.url),
                  size: asize,
                  onTap: () async {
                    await context.openById(routes.avatar, _user.id);
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
