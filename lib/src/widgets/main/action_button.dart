import 'package:flutter/material.dart';
import 'package:semesta/public/extensions/extension.dart';
import 'package:semesta/public/functions/format_helper.dart';
import 'package:semesta/src/widgets/sub/direction_x.dart';

class ActionButton extends StatefulWidget {
  final dynamic icon;
  final dynamic label;
  final Color? color;
  final double sizeIcon, textSize;
  final bool isActive; // 🔥 for liked/reposted/saved state
  final VoidCallback? onPressed;
  const ActionButton({
    super.key,
    this.icon,
    this.label,
    this.color,
    this.sizeIcon = 22,
    this.isActive = false,
    this.onPressed,
    this.textSize = 16,
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
    if (!widget.isActive) return; // only animate on "like"
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

    if (_tapped && !oldWidget.isActive && widget.isActive) {
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
            color: widget.color ?? context.hintColor,
          )
        : Image.asset(
            asImage(widget.icon, true),
            width: widget.sizeIcon,
            height: widget.sizeIcon,
            color: widget.color ?? context.hintColor,
          );

    return GestureDetector(
      onTap: () {
        _tapped = true;
        widget.onPressed?.call();
      },
      behavior: HitTestBehavior.opaque,
      child: DirectionX(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedScale(
            duration: Durations.medium2,
            scale: _scale,
            child: AnimatedOpacity(
              duration: Durations.medium2,
              opacity: _opacity,
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
                color: widget.color ?? context.hintColor,
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
