import 'package:flutter/material.dart';
import 'package:semesta/core/models/media_model.dart';
import 'package:semesta/ui/widgets/expandable_text.dart';
import 'package:semesta/ui/widgets/media_gallery.dart';

class ContentPostLayer extends StatelessWidget {
  final String title;
  final String id;
  final List<MediaModel> media;

  const ContentPostLayer({
    super.key,
    required this.title,
    required this.id,
    required this.media,
  });

  @override
  Widget build(BuildContext context) {
    // TEXT ONLY
    if (title.isNotEmpty && media.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(12),
        child: Text(title, style: const TextStyle(fontSize: 16, height: 1.4)),
      );
    }

    // BACKGROUND TEXT (colored or image background)
    if (media.isNotEmpty && media[0].type == MediaType.background) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(40),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(media[0].display),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Text(
            title,
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

    // MEDIA
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title.isNotEmpty) ExpandableText(text: title, trimLength: 100),
        MediaGallery(media: media, id: id),
      ],
    );
  }
}
