import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:semesta/core/controllers/user_controller.dart';
import 'package:semesta/ui/partials/image_preview.dart';

class AvatarPreviewPage extends StatelessWidget {
  final String userId;
  final bool isOwner;
  const AvatarPreviewPage({
    super.key,
    required this.userId,
    this.isOwner = false,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<UserController>();

    Future.microtask(() {
      isOwner ? controller.listenToUser(userId) : controller.one(userId);
    });

    return Obx(() {
      final data = isOwner
          ? controller.currentUser.value
          : controller.element.value;
      final avatar = data?.avatar ?? '';

      if (data == null) {
        return const Center(child: CircularProgressIndicator());
      }

      if (avatar.isEmpty) {
        return const Center(child: Text('No avatar available'));
      }

      return ImagePreview(images: [avatar]);
    });
  }
}
