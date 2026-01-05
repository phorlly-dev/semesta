import 'package:flutter/material.dart';
import 'package:semesta/app/functions/format.dart';
import 'package:semesta/ui/widgets/animated.dart';
import 'package:semesta/ui/widgets/custom_image.dart';

class AvatarAnimation extends StatelessWidget {
  final String imageUrl;
  final double size;
  final bool isNetwork;
  final VoidCallback? onTap;

  const AvatarAnimation({
    super.key,
    required this.imageUrl,
    this.size = 48,
    this.onTap,
    this.isNetwork = false,
  });

  @override
  Widget build(BuildContext context) {
    return Animated(
      onTap: onTap,
      child: CircleAvatar(
        radius: size / 2,
        backgroundImage: isNetwork
            ? NetworkImage(
                imageUrl.isNotEmpty
                    ? imageUrl
                    : 'https://i.pravatar.cc/150?img=8',
              )
            : null,
        child: !isNetwork
            ? ClipRRect(
                borderRadius: BorderRadius.circular(size / 2),
                child: CustomImage(
                  image: imageUrl.isNotEmpty
                      ? imageUrl
                      : setImage('default.png', true),
                  width: size,
                  height: size,
                ),
              )
            : null,
      ),
    );
  }
}
