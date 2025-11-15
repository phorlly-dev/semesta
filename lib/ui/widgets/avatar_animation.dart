import 'package:flutter/material.dart';
import 'package:semesta/app/utils/format.dart';
import 'package:semesta/ui/widgets/animated.dart';
import 'package:semesta/ui/widgets/custom_image.dart';

class AvatarAnimation extends StatelessWidget {
  final String? imageUrl;
  final double size;
  final VoidCallback? onTap;

  const AvatarAnimation({super.key, this.imageUrl, this.size = 44, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Animated(
      onTap: onTap,
      child: CircleAvatar(
        radius: size / 2,
        // backgroundImage: NetworkImage(imageUrl ?? setImage('main.png')),
        child: CustomImage(
          image: imageUrl ?? setImage('default.png', true),
          borderRadius: BorderRadius.circular(size / 2),
        ),
      ),
    );
  }
}
