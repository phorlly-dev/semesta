import 'package:flutter/material.dart';
import 'package:semesta/public/extensions/extension.dart';
import 'package:semesta/src/widgets/main/animated.dart';
import 'package:semesta/src/widgets/sub/direction_x.dart';

class DisplayName extends StatelessWidget {
  final String _data;
  final Color? color;
  final int maxChars;
  const DisplayName(this._data, {super.key, this.color, this.maxChars = 24});

  @override
  Widget build(BuildContext context) {
    return Text(
      _data.limitText(maxChars),
      style: TextStyle(
        fontSize: 16,
        overflow: TextOverflow.ellipsis,
        fontWeight: FontWeight.w600,
        color: color ?? context.colors.onSurface,
      ),
    );
  }
}

class Username extends StatelessWidget {
  final String _data;
  final Color? color;
  final int maxChars;
  final VoidCallback? onTap;
  const Username(
    this._data, {
    super.key,
    this.color,
    this.maxChars = 24,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Animated(
      onTap: onTap,
      child: Text(
        '@${_data.limitText(maxChars)}',
        style: TextStyle(
          fontSize: 16,
          overflow: TextOverflow.ellipsis,
          color: color ?? context.secondaryColor,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

class Status extends StatelessWidget {
  final DateTime? created;
  final IconData? icon;
  final Color? color;
  final bool hasIcon;
  const Status({
    super.key,
    this.created,
    this.icon,
    this.color,
    this.hasIcon = true,
  });

  @override
  Widget build(BuildContext context) {
    return DirectionX(
      crossAxisAlignment: CrossAxisAlignment.center,
      spacing: 4.2,
      children: [
        if (!hasIcon)
          Icon(Icons.circle, size: 3.2, color: context.secondaryColor),
        Text(
          created.toAgo,
          style: TextStyle(
            fontSize: 14.6,
            color: color ?? context.secondaryColor,
          ),
        ),

        if (hasIcon) ...[
          Icon(Icons.circle, size: 3.2, color: context.secondaryColor),
          Icon(icon, size: 12, color: context.primaryColor),
        ],
      ],
    );
  }
}

class Bio extends StatelessWidget {
  final String _data;
  final Color? color;
  const Bio(this._data, {super.key, this.color});

  @override
  Widget build(BuildContext context) {
    return Text(
      _data,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        fontSize: 16,
        color: color ?? context.colors.onSurface.withValues(alpha: 0.7),
      ),
    );
  }
}

class FollowYouBanner extends StatelessWidget {
  const FollowYouBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return DirectionX(
      spacing: 8,
      padding: const EdgeInsets.only(left: 30),
      children: [
        Icon(Icons.person, color: context.hintColor),
        Text(
          'Follows you',
          style: context.text.bodyMedium?.copyWith(
            fontWeight: FontWeight.w500,
            color: context.hintColor,
          ),
        ),
      ],
    );
  }
}
