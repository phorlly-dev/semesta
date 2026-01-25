import 'package:flutter/material.dart';
import 'package:semesta/public/extensions/extension.dart';
import 'package:semesta/src/widgets/main/animated.dart';

class DisplayName extends StatelessWidget {
  final String _data;
  final Color? color;
  final int maxChars;
  const DisplayName(this._data, {super.key, this.color, this.maxChars = 24});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Text(
      _data.limitText(maxChars),
      style: TextStyle(
        fontSize: 16,
        overflow: TextOverflow.ellipsis,
        fontWeight: FontWeight.w600,
        color: color ?? colors.onSurface,
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
          color: color ?? Theme.of(context).colorScheme.secondary,
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
    final colors = Theme.of(context).colorScheme;
    return Row(
      spacing: 4.2,
      children: [
        if (!hasIcon) Icon(Icons.circle, size: 3.2, color: colors.secondary),
        Text(
          created.toAgo,
          style: TextStyle(fontSize: 14.6, color: color ?? colors.secondary),
        ),

        if (hasIcon) ...[
          Icon(Icons.circle, size: 3.2, color: colors.secondary),
          Icon(icon, size: 12, color: colors.primary),
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
    final colors = Theme.of(context).colorScheme;
    return Text(
      _data,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        fontSize: 16,
        color: color ?? colors.onSurface.withValues(alpha: 0.7),
      ),
    );
  }
}

class FollowYouBanner extends StatelessWidget {
  const FollowYouBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(left: 42),
      child: Row(
        spacing: 8,
        children: [
          Icon(Icons.person, color: theme.hintColor),
          Text(
            'Follows you',
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500,
              color: theme.hintColor,
            ),
          ),
        ],
      ),
    );
  }
}
