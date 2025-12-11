import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:semesta/core/models/media_model.dart';
import 'package:semesta/ui/widgets/media_item.dart';

class MediaGallery extends StatelessWidget {
  final String id;
  final double spaceX;
  final List<MediaModel> media; // image or video URLs

  const MediaGallery({
    super.key,
    required this.media,
    required this.id,
    this.spaceX = 16,
  });

  @override
  Widget build(BuildContext context) {
    if (media.isEmpty) return const SizedBox();

    // For single media
    if (media.length == 1) {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: spaceX, vertical: 8),
        child: MediaItem(
          id: id,
          type: media[0].type,
          url: media[0].display,
          height: .42.sh,
          width: 8.sw,
        ),
      );
    }

    return SizedBox(
      height: 220.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: spaceX, vertical: 8),
        itemCount: media.length,
        separatorBuilder: (ctx, idx) => const SizedBox(width: 6),
        itemBuilder: (context, index) {
          final m = media[index];
          return MediaItem(
            id: id,
            url: m.display,
            type: m.type,
            height: 210.h,
            width: .48.sw,
            initIndex: index,
          );
        },
      ),
    );
  }
}
