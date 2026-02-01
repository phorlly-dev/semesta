import 'package:flutter/material.dart';
import 'package:semesta/app/models/media.dart';
import 'package:semesta/public/extensions/model_extension.dart';
import 'package:semesta/public/utils/params.dart';
import 'package:semesta/src/widgets/main/custom_image.dart';

class ImagedRender extends StatelessWidget {
  final Media _media;
  final VoidCallback? onTap;
  final double? size;
  final BorderRadiusGeometry? borderRadius;
  const ImagedRender(
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
              child: _media.mp4
                  ? CustomImage(
                      MediaSource.network(_media.thumbnails['url']),
                      onTap: onTap,
                    )
                  : CustomImage(
                      MediaSource.network(_media.display),
                      onTap: onTap,
                    ),
            ),

            // Video overlay
            if (_media.mp4)
              Container(
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.3),
                ),
                child: Icon(
                  Icons.play_circle_outline,
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
