import 'package:flutter/material.dart';
import 'package:semesta/ui/widgets/animated.dart';

class DisplayRepost extends StatelessWidget {
  final VoidCallback? onTap;
  final bool isOwner;
  final String displayName;

  const DisplayRepost({
    super.key,
    this.onTap,
    this.isOwner = false,
    required this.displayName,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
      child: Animated(
        onTap: onTap,
        child: Row(
          spacing: 6,
          children: [
            Icon(Icons.autorenew_rounded, color: theme.hintColor),
            Text(
              isOwner ? 'You reposted' : '$displayName reposted',
              style: theme.textTheme.bodyMedium?.copyWith(
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
