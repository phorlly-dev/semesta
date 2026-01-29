import 'package:flutter/material.dart';
import 'package:semesta/src/widgets/main/animated.dart';
import 'package:semesta/src/widgets/sub/direction_x.dart';

class CustomButton extends StatelessWidget {
  final dynamic icon;
  final String label;
  final VoidCallback? onPressed;
  final Color color;
  final double spaceX, spaceY;
  final double height;
  final Color textColor;
  final bool fullWidth;
  final BorderRadius? borderRadius;
  final bool enableShadow;

  const CustomButton({
    super.key,
    this.icon,
    required this.label,
    this.onPressed,
    this.color = const Color(0xFF2A2A2A),
    this.spaceX = 2,
    this.spaceY = 2,
    this.height = 48,
    this.textColor = Colors.white,
    this.fullWidth = true,
    this.borderRadius,
    this.enableShadow = false,
  });

  @override
  Widget build(BuildContext context) {
    final radius = borderRadius ?? BorderRadius.circular(12);

    return Animated(
      onTap: onPressed,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: spaceX, vertical: spaceY),
        width: fullWidth ? double.infinity : null,
        height: height,
        decoration: enableShadow
            ? BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: color.withValues(alpha: 0.3),
                    offset: const Offset(0, 4),
                    blurRadius: 8,
                  ),
                ],
              )
            : null,
        child: Material(
          color: color,
          borderRadius: radius,
          child: DirectionX(
            mainAxisSize: fullWidth ? MainAxisSize.max : MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null)
                icon is IconData
                    ? Icon(icon, size: 22, color: textColor)
                    : icon is Widget
                    ? SizedBox(height: 16, width: 16, child: icon)
                    : Image.asset(
                        icon,
                        width: 16,
                        height: 16,
                        color: textColor,
                      ),
              if (icon != null) const SizedBox(width: 10),
              Text(
                label,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: textColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
