import 'package:flutter/material.dart';
import 'package:semesta/app/functions/format.dart';
import 'package:semesta/ui/widgets/animated.dart';

class DisplayName extends StatelessWidget {
  final String data;
  final Color? color;
  final int maxChars;
  const DisplayName({
    super.key,
    required this.data,
    this.color,
    this.maxChars = 24,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Text(
      limitText(data, maxChars),
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
  final String data;
  final Color? color;
  final int maxChars;
  const Username({
    super.key,
    required this.data,
    this.color,
    this.maxChars = 12,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Text(
      '@${limitText(data, maxChars)}',
      style: TextStyle(
        fontSize: 15,
        overflow: TextOverflow.ellipsis,
        fontWeight: FontWeight.w500,
        color: color ?? colors.secondary,
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
          timeAgo(created),
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
  final String data;
  final Color? color;
  const Bio({super.key, required this.data, this.color});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(top: 3),
      child: Text(
        data,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontSize: 16,
          color: color ?? colors.onSurface.withValues(alpha: 0.7),
        ),
      ),
    );
  }
}

class FollowYou extends StatelessWidget {
  const FollowYou({super.key});

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

class DisplayRepost extends StatelessWidget {
  final VoidCallback? onTap;
  final String displayName;
  const DisplayRepost({super.key, this.onTap, required this.displayName});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: EdgeInsets.only(left: 30, top: 8),
      child: Animated(
        onTap: onTap,
        child: Row(
          spacing: 6,
          children: [
            Icon(Icons.autorenew_rounded, color: theme.hintColor),
            Text(
              '$displayName reposted',
              style: theme.textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.w500,
                color: theme.hintColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
