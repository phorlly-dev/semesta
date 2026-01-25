import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:semesta/public/functions/resolve_action.dart';
import 'package:semesta/public/helpers/generic_helper.dart';
import 'package:semesta/src/components/composer/generic_composer.dart';

class QuotePostPage extends StatelessWidget {
  final String _pid;
  const QuotePostPage(this._pid, {super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return GenericComposer(
        ComposerType.quote,
        parent: pctrl.dataMapping[_pid],
      );
    });
  }
}
