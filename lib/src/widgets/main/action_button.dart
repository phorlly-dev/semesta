import 'package:flutter/material.dart';
import 'package:semesta/public/extensions/context_extension.dart';
import 'package:semesta/public/extensions/string_extension.dart';
import 'package:semesta/public/functions/format_helper.dart';
import 'package:semesta/src/widgets/main/animated.dart';
import 'package:semesta/src/widgets/sub/direction_x.dart';

class ActionButton extends StatefulWidget {
  final dynamic icon;
  final dynamic label;
  final Color? iconColor, textColor;
  final double sizeIcon, textSize;
  final bool active; // 🔥 for liked/reposted/saved state
  final VoidCallback? onPressed;
  const ActionButton({
    super.key,
    this.icon,
    this.label,
    this.sizeIcon = 22,
    this.active = false,
    this.onPressed,
    this.textSize = 16,
    this.iconColor,
    this.textColor,
  });

  @override
  State<ActionButton> createState() => _ActionButtonState();
}

class _ActionButtonState extends State<ActionButton>
    with SingleTickerProviderStateMixin {
  double _scale = 1.0;
  double _opacity = 1.0;
  bool _tapped = false; // 🔑 local-only flag

  void _animate() async {
    if (!widget.active) return; // only animate on "like"
    setState(() {
      _scale = 2;
      _opacity = 0.8;
    });

    await Future.delayed(Durations.medium2);

    if (mounted) {
      setState(() {
        _scale = 1.0;
        _opacity = 1.0;
      });
    }
  }

  @override
  void didUpdateWidget(ActionButton oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (_tapped && !oldWidget.active && widget.active) {
      _animate();
      _tapped = false; // reset
    }
  }

  @override
  Widget build(BuildContext context) {
    final iconWidget = widget.icon is IconData
        ? Icon(
            widget.icon,
            size: widget.sizeIcon,
            color: widget.iconColor ?? context.hintColor,
          )
        : Image.asset(
            '${widget.icon}'.toAsset(true),
            width: widget.sizeIcon,
            height: widget.sizeIcon,
            color: widget.iconColor ?? context.hintColor,
          );

    return Animated(
      onTap: widget.onPressed != null
          ? () {
              _tapped = true;
              widget.onPressed!.call();
            }
          : null,
      child: DirectionX(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedScale(
            scale: _scale,
            duration: Durations.medium2,
            child: AnimatedOpacity(
              opacity: _opacity,
              duration: Durations.medium2,
              child: iconWidget,
            ),
          ),

          if (widget.label != null) ...[
            const SizedBox(width: 6),
            Text(
              widget.label is int
                  ? (widget.label > 0 ? toCount(widget.label ?? 0) : '')
                  : widget.label,
              style: TextStyle(
                color: widget.textColor ?? context.hintColor,
                fontSize: widget.textSize,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
