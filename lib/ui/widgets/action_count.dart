import 'package:flutter/material.dart';
import 'package:semesta/app/functions/format.dart';
import 'package:semesta/ui/widgets/animated.dart';

class ActionCount extends StatelessWidget {
  final int value;
  final String label;
  final VoidCallback? onTap;
  final double space;
  final Color? color;
  const ActionCount({
    super.key,
    required this.value,
    required this.label,
    this.onTap,
    this.space = 4.6,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Animated(
      onTap: onTap,
      child: Row(
        spacing: space,
        children: [
          Text(
            formatCount(value),
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: colors.secondary,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              color: color ?? colors.outline,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}
