import 'package:flutter/material.dart';
import 'package:semesta/app/models/media.dart';
import 'package:semesta/public/extensions/extension.dart';
import 'package:semesta/src/widgets/main/media_item.dart';

class MediaGallery extends StatelessWidget {
  final String id;
  final double start, end;
  final List<Media> media; // image or video URLs
  final BorderRadius? borderRadius;
  const MediaGallery({
    super.key,
    required this.media,
    required this.id,
    this.start = 56,
    this.end = 12,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    // For single media
    if (media.length == 1) {
      return Padding(
        padding: EdgeInsetsDirectional.only(start: start, end: end),
        child: AspectRatio(
          aspectRatio: 1,
          child: MediaItem(
            id: id,
            type: media[0].type,
            url: media[0].display,
            borderRadius: borderRadius,
          ),
        ),
      );
    }

    return SizedBox(
      height: 260,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: media.length,
        padding: EdgeInsetsDirectional.only(start: start, end: end),
        separatorBuilder: (_, idx) => const SizedBox(width: 8),
        itemBuilder: (_, index) {
          final m = media[index];
          return SizedBox(
            width: context.width * 0.48,
            child: MediaItem(
              id: id,
              url: m.display,
              type: m.type,
              initIndex: index,
              borderRadius: borderRadius,
            ),
          );
        },
      ),
    );
  }
}
