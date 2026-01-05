import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:semesta/core/controllers/post_controller.dart';
import 'package:semesta/core/models/media.dart';
import 'package:semesta/ui/partials/image_preview.dart';
import 'package:semesta/ui/widgets/data_binder.dart';

class ImagePreviewPage extends StatelessWidget {
  final String pid;
  final int index;
  const ImagePreviewPage({super.key, required this.pid, this.index = 0});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PostController>();

    return Obx(() {
      final data = controller.dataMapping[pid];
      final mediaList = data?.media;

      return DataBinder(
        isLoading: data == null,
        isEmpty: mediaList?.isEmpty ?? false,
        message: 'No media available',
        child: ImagePreview(
          images:
              mediaList?.map<String>((e) {
                if (e.type == MediaType.image) {
                  return e.display;
                } else {
                  return e.thumbnails['url'];
                }
              }).toList() ??
              const [],
          initialIndex: index,
        ),
      );
    });
  }
}
