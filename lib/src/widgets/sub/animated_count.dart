import 'package:flutter/material.dart';
import 'package:semesta/public/extensions/context_extension.dart';
import 'package:semesta/public/extensions/integer_extension.dart';
import 'package:semesta/public/helpers/feed_view.dart';
import 'package:semesta/public/helpers/params_helper.dart';
import 'package:semesta/src/widgets/main/animated.dart';
import 'package:semesta/src/widgets/sub/direction_x.dart';

class AnimatedCount extends StatelessWidget {
  final int _value;
  final FeedKind kind;
  final VoidCallback? onTap;
  final double space;
  final Color? color;
  final bool detailed;
  const AnimatedCount(
    this._value, {
    super.key,
    this.kind = FeedKind.posts,
    this.onTap,
    this.space = 4.6,
    this.color,
    this.detailed = false,
  });

  @override
  Widget build(BuildContext context) {
    final state = CountState.render(_value, kind);
    return Animated(
      onTap: onTap,
      child: DirectionX(
        spacing: space,
        children: [
          Text(
            detailed ? state.value.toString() : state.value.format,
            style: TextStyle(
              fontWeight: FontWeight.w900,
              color: context.secondaryColor,
            ),
          ),
          Text(
            state.key,
            style: TextStyle(
              color: color ?? context.outlineColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
