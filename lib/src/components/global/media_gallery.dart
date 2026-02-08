import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/context_extensions.dart';
import 'package:semesta/app/models/media.dart';
import 'package:semesta/src/widgets/main/media_render.dart';

class MediaGallery extends StatelessWidget {
  final String id;
  final double start, end;
  final List<Media> _media; // image or video URLs
  final BorderRadius? borderRadius;
  const MediaGallery(
    this._media, {
    super.key,
    this.id = '',
    this.start = 56,
    this.end = 12,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    final a = _media.length == 1;
    return Container(
      padding: a ? EdgeInsetsDirectional.only(start: start, end: end) : null,
      child: a
          ? AspectRatio(
              aspectRatio: 1,
              child: MediaRender(_media[0], id: id, borderRadius: borderRadius),
            )
          : SizedBox(
              height: 260,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: _media.length,
                padding: EdgeInsetsDirectional.only(start: start, end: end),
                separatorBuilder: (_, idx) => const SizedBox(width: 8),
                itemBuilder: (_, index) => SizedBox(
                  width: context.width * 0.48,
                  child: MediaRender(
                    _media[index],
                    id: id,
                    initIndex: index,
                    borderRadius: borderRadius,
                  ),
                ),
              ),
            ),
    );
  }
}
