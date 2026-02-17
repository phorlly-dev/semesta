import 'package:flutter/material.dart';
import 'package:semesta/public/utils/delegate.dart';
import 'package:semesta/public/helpers/params_helper.dart';
import 'package:semesta/src/widgets/sub/avatar_editable.dart';
import 'package:semesta/src/widgets/sub/cover_editable.dart';

class ProfileEditableHeader extends StatelessWidget {
  final double expanded;
  final MediaSource _avatar;
  final MediaSource _cover;
  final VoidCallback? onCover, onAvatar;
  const ProfileEditableHeader(
    this._avatar,
    this._cover, {
    super.key,
    this.expanded = 160,
    this.onCover,
    this.onAvatar,
  });

  @override
  Widget build(BuildContext context) {
    return SliverPersistentHeader(
      delegate: Delegate(
        rebuild: true,
        min: kToolbarHeight + 40,
        max: expanded,
        builder: (min, max, shrink) => Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned.fill(child: CoverEditable(_cover, onTap: onCover)),

            Positioned(
              left: 16,
              bottom: -36,
              child: AvatarEditable(_avatar, onTap: onAvatar, radius: 36),
            ),
          ],
        ),
      ),
    );
  }
}
