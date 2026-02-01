import 'package:flutter/material.dart';
import 'package:semesta/public/functions/resolve_action.dart';
import 'package:semesta/src/components/composer/generic_composer.dart';

class CreatePostPage extends StatelessWidget {
  const CreatePostPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GenericComposer(ComposerType.post);
  }
}
