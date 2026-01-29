import 'package:flutter/material.dart';

class DirectionY extends StatelessWidget {
  final double spacing;
  final List<Widget> children;
  final Decoration? decoration;
  final MainAxisSize mainAxisSize;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;
  const DirectionY({
    super.key,
    this.padding,
    this.margin,
    this.decoration,
    this.spacing = 0.0,
    this.children = const [],
    this.mainAxisSize = MainAxisSize.max,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.crossAxisAlignment = CrossAxisAlignment.start,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      padding: padding,
      decoration: decoration,
      child: Column(
        spacing: spacing,
        mainAxisSize: mainAxisSize,
        mainAxisAlignment: mainAxisAlignment,
        crossAxisAlignment: crossAxisAlignment,
        children: children,
      ),
    );
  }
}
