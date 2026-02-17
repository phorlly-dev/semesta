import 'package:flutter/material.dart';
import 'package:semesta/app/models/feed.dart';
import 'package:semesta/src/components/composer/generic_composer.dart';

class CreatePostPage extends StatelessWidget {
  const CreatePostPage({super.key});

  @override
  Widget build(BuildContext _) => GenericComposer(Create.post);
}
