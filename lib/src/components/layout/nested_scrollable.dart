import 'package:flutter/material.dart';
import 'package:semesta/public/utils/type_def.dart';

class NestedScrollable extends StatelessWidget {
  final Widget child;
  final bool floating;
  final Axis direction;
  final ScrollController? scroller;
  final Defo<bool, List<Widget>> builder;
  const NestedScrollable({
    super.key,
    required this.child,
    required this.builder,
    this.scroller,
    this.floating = false,
    this.direction = Axis.vertical,
  });

  @override
  Widget build(BuildContext context) {
    return NestedScrollView(
      body: child,
      controller: scroller,
      scrollDirection: direction,
      floatHeaderSlivers: floating,
      headerSliverBuilder: (_, innerBox) => builder.call(innerBox),
    );
  }
}
