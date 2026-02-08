import 'package:flutter/material.dart';
import 'package:semesta/public/helpers/params_helper.dart';
import 'package:semesta/src/widgets/main/custom_image.dart';

class AvatarAnimation extends StatelessWidget {
  final MediaSource _source;
  final double size;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? padding;
  final Decoration? decoration;
  const AvatarAnimation(
    this._source, {
    super.key,
    this.size = 36,
    this.onTap,
    this.padding,
    this.decoration,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: decoration,
      child: CircleAvatar(
        radius: size * 0.5,
        backgroundColor: Colors.transparent,
        child: ClipOval(
          child: CustomImage(_source, width: size, height: size, onTap: onTap),
        ),
      ),
    );
  }
}
