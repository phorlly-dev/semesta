import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:semesta/core/views/generic_helper.dart';
import 'package:semesta/core/models/media.dart';
import 'package:semesta/ui/widgets/custom_image.dart';
import 'package:semesta/ui/widgets/custom_video_player.dart';

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
          ? CustomVideoPlayer(video: url)
          : CustomImage(
              image: url,
              onTap: () async {
                await context.pushNamed(
                  route.media.name,
                  pathParameters: {'id': id},
                  queryParameters: {'index': initIndex.toString()},
                );
              },
            ),
    );
  }
}
