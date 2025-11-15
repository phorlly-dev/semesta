import 'package:flutter/material.dart';
import 'package:semesta/ui/widgets/custom_image.dart';
import 'package:semesta/ui/widgets/custom_video_player.dart';
import 'package:semesta/ui/widgets/expandable_text.dart';

class PostContent extends StatelessWidget {
  final String? background;
  final String? title;
  final List<String>? images, videos;

  const PostContent({
    super.key,
    this.background,
    this.title,
    this.images,
    this.videos,
  });

  @override
  Widget build(BuildContext context) {
    final hasImages = (images != null && images!.isNotEmpty);
    final hasVideos = (videos != null && videos!.isNotEmpty);

    // TEXT ONLY
    if (!hasImages && !hasVideos && background == null) {
      return Padding(
        padding: const EdgeInsets.all(12),
        child: Text(
          title ?? '',
          style: const TextStyle(fontSize: 16, height: 1.4),
        ),
      );
    }

    // BACKGROUND TEXT (colored or image background)
    if (background != null) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(40),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(background!),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Text(
            title ?? '',
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );
    }

    // MULTIPLE IMAGES (Grid like Facebook)
    if (hasImages) {
      final imgs = images!;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: ExpandableText(text: title!, trimLength: 89),
            ),
          if (imgs.length == 1)
            CustomImage(
              image: imgs.first,
              width: double.infinity,
              borderRadius: BorderRadius.zero,
            )
          else
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: imgs.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 2,
                crossAxisSpacing: 2,
              ),
              itemBuilder: (_, i) =>
                  CustomImage(image: imgs[i], fit: BoxFit.cover),
            ),
        ],
      );
    }

    // SINGLE OR MULTIPLE VIDEOS
    if (hasVideos) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null) ExpandableText(text: title!, trimLength: 89),

          // ...videos!.map(
          //   (v) => AspectRatio(
          //     aspectRatio: 16 / 9,
          //     child: CustomVideoPlayer(video: v),
          //   ),
          // ),
          AspectRatio(
            aspectRatio: 16 / 9,
            child: CustomVideoPlayer(video: videos![1]),
          ),
        ],
      );
    }

    return const SizedBox.shrink();
  }
}
