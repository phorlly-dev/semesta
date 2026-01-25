import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:semesta/public/functions/resolve_action.dart';
import 'package:semesta/public/helpers/generic_helper.dart';
import 'package:semesta/src/components/composer/generic_composer.dart';

class CommnetPostPage extends StatelessWidget {
  final String _pid;
  const CommnetPostPage(this._pid, {super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return GenericComposer(
        ComposerType.reply,
        parent: pctrl.dataMapping[_pid],
      );
    });
  }
}
