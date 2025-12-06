import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:semesta/core/controllers/post_controller.dart';
import 'package:semesta/ui/partials/image_preview.dart';

class ImagePreviewPage extends StatelessWidget {
  final String postId;
  const ImagePreviewPage({super.key, required this.postId});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PostController>();

    Future.microtask(() => controller.listenToPost(postId));

    return Obx(() {
      final data = controller.postsMap[postId]?.value;

      if (data == null) {
        return const Center(child: CircularProgressIndicator());
      }

      final mediaList = data.media;
      if (mediaList.isEmpty) {
        return const Center(child: Text('No media available'));
      }

      return ImagePreview(images: mediaList.map((e) => e.display).toList());
    });
  }
}
