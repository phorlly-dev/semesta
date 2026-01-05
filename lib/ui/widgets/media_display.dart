import 'package:flutter/material.dart';
import 'package:semesta/core/models/media.dart';
import 'package:semesta/ui/widgets/custom_image.dart';

class MediaDisplay extends StatelessWidget {
  final Media media;
  final VoidCallback? onTap;
  final double? size;
  final BorderRadiusGeometry? borderRadius;
  const MediaDisplay({
    super.key,
    required this.media,
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
              child: media.type == MediaType.image
                  ? CustomImage(image: media.display, onTap: onTap)
                  : CustomImage(image: media.thumbnails['url'], onTap: onTap),
            ),

            // Video overlay
            if (media.type == MediaType.video)
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
