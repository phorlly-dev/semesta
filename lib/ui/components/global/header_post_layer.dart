import 'package:flutter/material.dart';
import 'package:semesta/app/functions/format.dart';
import 'package:semesta/ui/widgets/animated.dart';
import 'package:semesta/ui/widgets/avatar_animation.dart';

class HeaderPostLayer extends StatelessWidget {
  final String name, username, avatar;
  final DateTime? created;
  final bool isVerified;
  final VoidCallback? onDetails, onProfile;
  final Widget? action;
  final IconData visibility;

  const HeaderPostLayer({
    super.key,
    required this.name,
    required this.username,
    required this.avatar,
    this.created,
    this.isVerified = false,
    this.onDetails,
    this.onProfile,
    this.visibility = Icons.public,
    this.action,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return ListTile(
      dense: true,
      onTap: onDetails,
      leading: AvatarAnimation(imageUrl: avatar, onTap: onProfile),
      title: Animated(
        onTap: onProfile,
        child: Row(
          spacing: 3.2,
          children: [
            Text(
              name,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),

            if (isVerified)
              Icon(Icons.verified, color: colors.primary, size: 15),

            Text(
              '@${limitText(username, 16)}',
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 14.8,
                fontWeight: FontWeight.w500,
                color: colors.secondary,
              ),
            ),
          ],
        ),
      ),
      subtitle: Row(
        spacing: 3.2,
        children: [
          Text(
            timeAgo(created),
            style: TextStyle(fontSize: 13.6, color: colors.secondary),
          ),
          Icon(Icons.circle, size: 3.2, color: colors.secondary),
          Icon(visibility, size: 12, color: colors.primary),
        ],
      ),
      trailing: action,
    );
  }
}
