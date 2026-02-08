import 'package:flutter/material.dart';

typedef DBuilder = Widget Function(double min, double max, double shrink);

class Delegate extends SliverPersistentHeaderDelegate {
  final bool rebuild;
  final double min, max;
  final DBuilder builder;
  const Delegate({
    this.rebuild = false,
    this.min = 0,
    this.max = 0,
    required this.builder,
  });

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) => builder.call(min, max, shrinkOffset);

  @override
  double get maxExtent => max;

  @override
  double get minExtent => min;

  @override
  bool shouldRebuild(covariant Delegate oldDelegate) => rebuild;
}
