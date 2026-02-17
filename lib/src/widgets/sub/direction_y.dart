import 'package:flutter/material.dart';

class DirectionY extends StatelessWidget {
  final Color? color;
  final double spacing;
  final List<Widget> children;
  final Decoration? decoration;
  final MainAxisSize size;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final AlignmentGeometry? alignment;
  final MainAxisAlignment mainAlignment;
  final CrossAxisAlignment crossAlignment;
  const DirectionY({
    super.key,
    this.color,
    this.padding,
    this.margin,
    this.alignment,
    this.decoration,
    this.spacing = 0.0,
    this.children = const [],
    this.size = MainAxisSize.max,
    this.mainAlignment = MainAxisAlignment.start,
    this.crossAlignment = CrossAxisAlignment.start,
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
        mainAxisSize: size,
        mainAxisAlignment: mainAlignment,
        crossAxisAlignment: crossAlignment,
        children: children,
      ),
    );
  }
}
