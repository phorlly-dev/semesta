import 'package:flutter/material.dart';
import 'package:semesta/app/functions/post_action.dart';
import 'package:semesta/ui/partials/generic_composer.dart';

class CreatePostPage extends StatelessWidget {
  const CreatePostPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GenericComposer(type: ComposerType.post);
  }
}
