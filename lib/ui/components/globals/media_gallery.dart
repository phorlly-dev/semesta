import 'package:flutter/material.dart';
import 'package:semesta/core/models/media.dart';
import 'package:semesta/ui/widgets/media_item.dart';

class MediaGallery extends StatelessWidget {
  final String id;
  final double height, start, end;
  final List<Media> media; // image or video URLs
  final BorderRadius? borderRadius;
  const MediaGallery({
    super.key,
    required this.media,
    required this.id,
    this.height = 360,
    this.start = 60,
    this.end = 12,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    final feedWidth = MediaQuery.of(context).size.width;

    // For single media
    if (media.length == 1) {
      return Padding(
        padding: EdgeInsetsDirectional.only(start: start, end: end),
        child: AspectRatio(
          aspectRatio: .89,
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
        separatorBuilder: (ctx, idx) => const SizedBox(width: 6),
        itemBuilder: (context, index) {
          final m = media[index];
          return SizedBox(
            width: feedWidth * 0.48,
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
