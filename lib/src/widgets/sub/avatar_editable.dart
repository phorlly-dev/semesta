import 'package:flutter/material.dart';
import 'package:semesta/public/helpers/params_helper.dart';
import 'package:semesta/src/widgets/sub/animated_avatar.dart';

class AvatarEditable extends StatelessWidget {
  final double radius;
  final VoidCallback? onTap;
  final MediaSource _source;
  final double spacing;
  const AvatarEditable(
    this._source, {
    super.key,
    this.radius = 46,
    this.onTap,
    this.spacing = 6,
  });

  @override
  Widget build(BuildContext context) {
    final size = radius * 2;
    return InkWell(
      onTap: onTap,
      customBorder: const CircleBorder(),
      child: Stack(
        clipBehavior: Clip.none,
        alignment: AlignmentGeometry.center,
        children: [
          AnimatedAvatar(
            _source,
            size: size,
            padding: EdgeInsets.symmetric(vertical: spacing),
          ),

          // Dark overlay (optional but very X-like)
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.black.withValues(alpha: 0.35),
            ),
          ),

          // Camera button
          Material(
            color: Colors.transparent,
            child: Container(
              width: size,
              height: size,
              alignment: Alignment.center,
              child: Icon(
                Icons.camera_alt_outlined,
                color: Colors.white,
                size: 24,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
