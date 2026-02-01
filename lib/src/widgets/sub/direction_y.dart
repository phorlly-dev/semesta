import 'package:flutter/material.dart';

class DirectionY extends StatelessWidget {
  final Color? color;
  final double spacing;
  final List<Widget> children;
  final Decoration? decoration;
  final MainAxisSize mainAxisSize;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final AlignmentGeometry? alignment;
  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;
  const DirectionY({
    super.key,
    this.color,
    this.padding,
    this.margin,
    this.alignment,
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
      color: color,
      margin: margin,
      padding: padding,
      alignment: alignment,
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
