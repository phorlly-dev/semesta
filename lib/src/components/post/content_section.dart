import 'package:flutter/material.dart';
import 'package:semesta/app/models/feed.dart';
import 'package:semesta/src/components/global/media_gallery.dart';

class ContentSection extends StatelessWidget {
  final Feed _post;
  const ContentSection(this._post, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_post.title.isNotEmpty)
            Text(_post.title, style: const TextStyle(fontSize: 16)),

          const SizedBox(height: 8),

          if (_post.media.isNotEmpty) ...[
            MediaGallery(media: _post.media, id: _post.id, start: 0, end: 0),
            SizedBox(height: 6),
          ],
        ],
      ),
    );
  }
}
