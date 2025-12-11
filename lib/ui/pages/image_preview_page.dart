import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:semesta/core/controllers/post_controller.dart';
import 'package:semesta/ui/partials/image_preview.dart';
import 'package:semesta/ui/widgets/data_binder.dart';

class ImagePreviewPage extends StatelessWidget {
  final String postId;
  final int index;
  const ImagePreviewPage({super.key, required this.postId, this.index = 0});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PostController>();

    return Obx(() {
      final data = controller.dataMapping[postId];
      final mediaList = data?.media;

      return DataBinder(
        isLoading: data == null,
        isEmpty: mediaList?.isEmpty ?? false,
        message: 'No media available',
        child: ImagePreview(
          images: mediaList?.map((e) => e.display).toList() ?? const [],
          initialIndex: index,
        ),
      );
    });
  }
}
