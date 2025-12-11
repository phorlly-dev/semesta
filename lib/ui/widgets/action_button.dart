import 'package:flutter/material.dart';
import 'package:semesta/app/functions/format.dart';

class ActionButton extends StatefulWidget {
  final dynamic icon;
  final dynamic label;
  final Color? iconColor;
  final double sizeIcon;
  final bool isActive; // 🔥 for liked/reposted/saved state
  final VoidCallback? onPressed;

  const ActionButton({
    super.key,
    this.icon,
    this.label,
    this.iconColor,
    this.sizeIcon = 24,
    this.isActive = false,
    this.onPressed,
  });

  @override
  State<ActionButton> createState() => _ActionButtonState();
}

class _ActionButtonState extends State<ActionButton>
    with SingleTickerProviderStateMixin {
  double _scale = 1.0;
  double _opacity = 1.0;

  void _animate() async {
    if (!widget.isActive) return; // only animate on "like"
    setState(() {
      _scale = 2.6;
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
    // Detect state change from unliked → liked
    if (!oldWidget.isActive && widget.isActive) {
      _animate();
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).hintColor;
    final iconWidget = widget.icon is IconData
        ? Icon(
            widget.icon,
            size: widget.sizeIcon,
            color: widget.iconColor ?? color,
          )
        : Image.asset(
            setImage(widget.icon, true),
            width: widget.sizeIcon,
            height: widget.sizeIcon,
            color: widget.iconColor ?? color,
          );

    return GestureDetector(
      onTap: widget.onPressed,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        child: Row(
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
                widget.label is int ? formatCount(widget.label!) : widget.label,
                style: TextStyle(
                  color: color,
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
