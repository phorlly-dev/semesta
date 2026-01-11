import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:semesta/app/functions/post_action.dart';
import 'package:semesta/core/views/generic_helper.dart';
import 'package:semesta/ui/partials/generic_composer.dart';

class ReplyToPostPage extends StatelessWidget {
  final String pid;
  const ReplyToPostPage({super.key, required this.pid});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return GenericComposer(
        type: ComposerType.reply,
        parent: pctrl.dataMapping[pid],
      );
    });
  }
}
