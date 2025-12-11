import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:semesta/app/routes/routes.dart';
import 'package:semesta/core/models/media_model.dart';
import 'package:semesta/ui/widgets/custom_image.dart';
import 'package:semesta/ui/widgets/custom_video_player.dart';

class MediaItem extends StatelessWidget {
  final String url, id;
  final double width;
  final double height;
  final MediaType type;
  final double radius;
  final int initIndex;
  const MediaItem({
    super.key,
    required this.url,
    required this.width,
    required this.height,
    required this.type,
    required this.id,
    this.radius = 12,
    this.initIndex = 0,
  });

  bool get isVideo => type == MediaType.video;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: isVideo
          ? CustomVideoPlayer(video: url)
          : CustomImage(
              image: url,
              width: width,
              height: height,
              borderRadius: BorderRadius.circular(radius),
              onTap: () async {
                await context.pushNamed(
                  Routes().imagesPreview.name,
                  pathParameters: {'id': id},
                  queryParameters: {'index': initIndex.toString()},
                );
              },
            ),
    );
  }
}
