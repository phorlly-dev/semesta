import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:semesta/app/functions/post_action.dart';
import 'package:semesta/core/controllers/action_controller.dart';
import 'package:semesta/ui/partials/generic_composer.dart';

class ReplyToPostPage extends StatelessWidget {
  final String postId;
  const ReplyToPostPage({super.key, required this.postId});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ActionController>();

    Future.microtask(() => controller.listenToPost(postId));

    return Obx(() {
      final post = controller.postsMap[postId]?.value;

      return GenericComposer(type: ComposerType.reply, parent: post);
    });
  }
}
