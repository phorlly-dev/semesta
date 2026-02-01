import 'package:flutter/material.dart';
import 'package:semesta/public/utils/delegate.dart';
import 'package:semesta/public/utils/params.dart';
import 'package:semesta/src/widgets/sub/avatar_editale.dart';
import 'package:semesta/src/widgets/sub/cover_editable.dart';

class ProfileEditableHeader extends StatelessWidget {
  final double expanded;
  final MediaSource _avatarSource;
  final MediaSource _coverSource;
  final VoidCallback? onCover, onAvatar;
  const ProfileEditableHeader(
    this._avatarSource,
    this._coverSource, {
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
            Positioned.fill(child: CoverEditable(_coverSource, onTap: onCover)),

            Positioned(
              left: 16,
              bottom: -36,
              child: AvatarEditale(_avatarSource, onTap: onAvatar, radius: 36),
            ),
          ],
        ),
      ),
    );
  }
}
