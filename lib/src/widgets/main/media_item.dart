import 'package:flutter/material.dart';
import 'package:semesta/public/extensions/extension.dart';
import 'package:semesta/app/models/media.dart';
import 'package:semesta/public/helpers/generic_helper.dart';
import 'package:semesta/src/widgets/main/custom_image.dart';
import 'package:semesta/src/widgets/main/custom_video_player.dart';

class MediaItem extends StatelessWidget {
  final String url, id;
  final MediaType type;
  final double radius;
  final int initIndex;
  final BorderRadius? borderRadius;
  const MediaItem({
    super.key,
    required this.url,
    required this.type,
    required this.id,
    this.radius = 12,
    this.initIndex = 0,
    this.borderRadius,
  });

  bool get isVideo => type == MediaType.video;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius ?? BorderRadius.circular(radius),
      child: isVideo
          ? CustomVideoPlayer(url)
          : CustomImage(
              url,
              onTap: () async {
                await context.openPreview(route.media, id, initIndex);
              },
            ),
    );
  }
}
