import 'package:flutter/material.dart';

class ContentSliverLayer extends StatelessWidget {
  final Widget content;
  final ScrollController? scroller;
  final List<Widget> Function(bool innerScrolled) builder;
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
      headerSliverBuilder: (context, innerScrolled) => builder(innerScrolled),
      body: content,
    );
  }
}
