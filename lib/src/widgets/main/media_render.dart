import 'package:flutter/material.dart';
import 'package:semesta/public/extensions/extension.dart';
import 'package:semesta/app/models/media.dart';
import 'package:semesta/public/extensions/model_extension.dart';
import 'package:semesta/public/helpers/generic_helper.dart';
import 'package:semesta/public/utils/params.dart';
import 'package:semesta/src/widgets/main/custom_image.dart';
import 'package:semesta/src/widgets/main/video_playable.dart';

class MediaRender extends StatelessWidget {
  final String id;
  final Media _media;
  final double radius;
  final int initIndex;
  final BorderRadius? borderRadius;
  const MediaRender(
    this._media, {
    super.key,
    this.id = '',
    this.radius = 12,
    this.initIndex = 0,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius ?? BorderRadius.circular(radius),
      child: _media.mp4
          ? VideoPlayable(MediaSource.network(_media.display))
          : CustomImage(
              MediaSource.network(_media.display),
              onTap: () async {
                await context.openPreview(route.media, id, initIndex);
              },
            ),
    );
  }
}
