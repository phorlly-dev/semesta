import 'dart:io';
import 'package:flutter/material.dart';
import 'package:semesta/app/functions/format_helper.dart';
import 'package:semesta/ui/widgets/animated.dart';

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
                  : AssetImage(setImage('default.png', true)),
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
