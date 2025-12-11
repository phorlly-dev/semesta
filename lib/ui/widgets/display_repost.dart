import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
      padding: EdgeInsets.only(left: .1.sw, top: 8),
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
