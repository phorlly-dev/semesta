import 'dart:io';
import 'package:flutter/material.dart';
import 'package:semesta/public/extensions/extension.dart';
import 'package:semesta/src/widgets/main/animated.dart';

class ImagePicker extends StatelessWidget {
  final double size;
  final VoidCallback? onTap;
  final File? image;
  final double spacing;
  const ImagePicker({
    super.key,
    this.size = 48,
    this.onTap,
    this.image,
    this.spacing = 4,
  });

  @override
  Widget build(BuildContext context) {
    return Animated(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: spacing),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.grey, width: 3),
        ),
        child: Stack(
          children: [
            CircleAvatar(
              radius: size,
              backgroundImage: image != null
                  ? FileImage(image!)
                  : AssetImage('default.png'.asImage(true)),
            ),
            Positioned(
              bottom: 0,
              right: 6,
              child: Icon(Icons.camera_alt_rounded),
            ),
          ],
        ),
      ),
    );
  }
}
