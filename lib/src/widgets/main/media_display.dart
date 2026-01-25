import 'package:flutter/material.dart';
import 'package:semesta/app/models/media.dart';
import 'package:semesta/src/widgets/main/custom_image.dart';

class MediaDisplay extends StatelessWidget {
  final Media _media;
  final VoidCallback? onTap;
  final double? size;
  final BorderRadiusGeometry? borderRadius;
  const MediaDisplay(
    this._media, {
    super.key,
    this.onTap,
    this.size,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius ?? BorderRadius.circular(8),
      child: AspectRatio(
        aspectRatio: 1.2,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Background
            Positioned.fill(
              child: _media.type == MediaType.image
                  ? CustomImage(_media.display, onTap: onTap)
                  : CustomImage(_media.thumbnails['url'], onTap: onTap),
            ),

            // Video overlay
            if (_media.type == MediaType.video)
              Container(
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.3),
                ),
                child: Icon(
                  Icons.play_circle_fill,
                  size: size ?? 64,
                  color: Colors.white,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
