import 'package:flutter/material.dart';
import 'package:semesta/public/extensions/extension.dart';
import 'package:semesta/public/helpers/utils_helper.dart';
import 'package:semesta/src/widgets/main/animated.dart';

class ActionCount extends StatelessWidget {
  final int _value;
  final FeedKind kind;
  final VoidCallback? onTap;
  final double space;
  final Color? color;
  const ActionCount(
    this._value, {
    super.key,
    this.kind = FeedKind.posted,
    this.onTap,
    this.space = 4.6,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final state = countState(_value, kind);

    return Animated(
      onTap: onTap,
      child: Row(
        spacing: space,
        children: [
          Text(
            state.value.toCount,
            style: TextStyle(
              fontWeight: FontWeight.w900,
              color: colors.secondary,
            ),
          ),
          Text(
            state.key,
            style: TextStyle(
              color: color ?? colors.outline,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
