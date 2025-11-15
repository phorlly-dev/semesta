import 'package:flutter/material.dart';
import 'package:semesta/ui/widgets/avatar_animation.dart';
import 'package:semesta/ui/widgets/custom_status.dart';
import 'package:semesta/ui/widgets/group_button.dart';

class PostHeader extends StatelessWidget {
  final String name, avatar, created;
  const PostHeader({
    super.key,
    required this.name,
    required this.avatar,
    required this.created,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // --- Avatar ---
          AvatarAnimation(imageUrl: avatar, onTap: () {}),
          const SizedBox(width: 10),

          // --- Name + Time + Follow ---
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  spacing: 4,
                  children: [
                    Flexible(
                      child: Text(
                        name,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                        ),
                      ),
                    ),
                    Text('•', style: TextStyle(color: Colors.grey[600])),
                    TextButton(
                      onPressed: () {},
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: const Size(40, 24),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: const Text(
                        'Follow',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Colors.blueAccent,
                        ),
                      ),
                    ),
                  ],
                ),
                CustomStatus(text: created),
              ],
            ),
          ),

          // --- Options (three dots or group icon) ---
          GroupButton(onClose: () {}, onView: () {}),
        ],
      ),
    );
  }
}
