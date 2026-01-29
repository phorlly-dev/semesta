import 'package:flutter/material.dart';
import 'package:semesta/public/extensions/extension.dart';
import 'package:semesta/src/widgets/main/custom_image.dart';
import 'package:semesta/src/widgets/main/animated.dart';

class AvatarAnimation extends StatelessWidget {
  final String _imageUrl;
  final double size;
  final bool isNetwork;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? padding;
  const AvatarAnimation(
    this._imageUrl, {
    super.key,
    this.size = 36,
    this.onTap,
    this.isNetwork = false,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      child: Animated(
        onTap: onTap,
        child: CircleAvatar(
          radius: size * 0.5,
          backgroundImage: isNetwork
              ? NetworkImage(
                  _imageUrl.isNotEmpty
                      ? _imageUrl
                      : 'https://i.pravatar.cc/150?img=8',
                )
              : null,
          backgroundColor: Colors.transparent,
          child: !isNetwork
              ? ClipOval(
                  child: CustomImage(
                    _imageUrl.isNotEmpty
                        ? _imageUrl
                        : 'default.png'.asImage(true),
                    width: size,
                    height: size,
                  ),
                )
              : null,
        ),
      ),
    );
  }
}
