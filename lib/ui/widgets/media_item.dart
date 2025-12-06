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

  const MediaItem({
    super.key,
    required this.url,
    required this.width,
    required this.height,
    required this.type,
    required this.id,
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
              borderRadius: BorderRadius.circular(12),
              onTap: () {
                context.pushNamed(
                  Routes().imagesPreview.name,
                  pathParameters: {'id': id},
                );
              },
            ),
    );
  }
}
