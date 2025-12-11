import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:semesta/app/functions/post_action.dart';
import 'package:semesta/core/controllers/post_controller.dart';
import 'package:semesta/ui/partials/generic_composer.dart';

class ReplyToPostPage extends StatelessWidget {
  final String postId;
  const ReplyToPostPage({super.key, required this.postId});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PostController>();

    return Obx(() {
      return GenericComposer(
        type: ComposerType.reply,
        parent: controller.dataMapping[postId],
      );
    });
  }
}
