import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:semesta/core/controllers/user_controller.dart';
import 'package:semesta/ui/partials/image_preview.dart';
import 'package:semesta/ui/widgets/data_binder.dart';

class AvatarPreviewPage extends StatelessWidget {
  final String uid;
  const AvatarPreviewPage({super.key, required this.uid});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<UserController>();
    return Obx(() {
      final data = controller.dataMapping[uid];
      final avatar = data?.avatar ?? '';

      return DataBinder(
        isEmpty: avatar.isEmpty,
        isLoading: data == null,
        message: 'No avatar available',
        child: ImagePreview(images: [avatar]),
      );
    });
  }
}
