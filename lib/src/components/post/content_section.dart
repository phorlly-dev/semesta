import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:semesta/app/models/feed.dart';
import 'package:semesta/public/extensions/model_extension.dart';
import 'package:semesta/public/helpers/generic_helper.dart';
import 'package:semesta/src/components/global/media_gallery.dart';
import 'package:semesta/src/components/info/referenced_to_post.dart';
import 'package:semesta/src/widgets/sub/direction_y.dart';

class ContentSection extends StatelessWidget {
  final Feed _post;
  const ContentSection(this._post, {super.key});

  @override
  Widget build(BuildContext context) {
    return DirectionY(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      children: [
        if (_post.hasComment) ...[const SizedBox(height: 4), _justReferenced],

        if (_post.title.isNotEmpty) ...[
          Text(_post.title, style: const TextStyle(fontSize: 16)),
          const SizedBox(height: 8),
        ],

        if (_post.media.isNotEmpty) ...[
          MediaGallery(_post.media, id: _post.id, start: 0, end: 0),
          const SizedBox(height: 6),
        ],
      ],
    );
  }

  Widget get _justReferenced {
    return Obx(() {
      final parent = pctrl.dataMapping[_post.pid];
      final actor = uctrl.dataMapping[parent?.uid ?? _post.uid];

      return parent == null || actor == null
          ? const SizedBox.shrink()
          : ReferencedToPost(actor.id);
    });
  }
}
