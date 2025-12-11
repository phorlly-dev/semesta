import 'package:flutter/material.dart';
import 'package:semesta/app/utils/type_def.dart';

class ContentSliverLayer extends StatelessWidget {
  final Widget content;
  final ScrollController? scroller;
  final BuilderCallback<bool, List<Widget>> builder;
  const ContentSliverLayer({
    super.key,
    required this.content,
    required this.builder,
    this.scroller,
  });

  @override
  Widget build(BuildContext context) {
    return NestedScrollView(
      floatHeaderSlivers: true,
      controller: scroller,
      headerSliverBuilder: (context, boxIsScrolled) => builder(boxIsScrolled),
      body: content,
    );
  }
}
