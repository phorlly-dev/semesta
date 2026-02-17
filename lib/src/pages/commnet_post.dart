import 'package:flutter/material.dart';
import 'package:semesta/app/models/feed.dart';
import 'package:semesta/public/helpers/generic_helper.dart';
import 'package:semesta/src/components/composer/generic_composer.dart';

class CommnetPostPage extends StatelessWidget {
  final String _pid;
  const CommnetPostPage(this._pid, {super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: pctrl.loadFeed(_pid),
      builder: (_, snapshot) {
        return GenericComposer(Create.reply, parent: snapshot.data);
      },
    );
  }
}
