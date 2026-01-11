import 'package:flutter/material.dart';
import 'package:semesta/app/functions/format_helper.dart';
import 'package:semesta/core/models/author.dart';
import 'package:semesta/core/models/feed.dart';
import 'package:semesta/ui/widgets/media_display.dart';
import 'package:semesta/ui/components/posts/post_editor.dart';
import 'package:semesta/ui/components/users/user_info.dart';
import 'package:semesta/ui/widgets/avatar_animation.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

class RepostEditor extends StatelessWidget {
  final String avatar;
  final String? label;
  final Feed post;
  final Author actor;
  final TextEditingController content;
  final ValueChanged<int>? onRemove;
  final ValueChanged<String>? onChanged;
  final List<AssetEntity> assets;
  const RepostEditor({
    super.key,
    required this.avatar,
    this.label,
    required this.content,
    this.onChanged,
    required this.post,
    this.onRemove,
    required this.assets,
    required this.actor,
  });

  @override
  Widget build(BuildContext context) {
    return PostEditor(
      avatar: avatar,
      content: content,
      label: label,
      onChanged: onChanged,
      assets: assets,
      onRemove: onRemove,
      bottom: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      AvatarAnimation(imageUrl: actor.avatar, size: 32),

                      const SizedBox(width: 8),
                      DisplayName(data: actor.name),

                      const Spacer(),
                      Text(
                        timeAgo(post.createdAt),
                        style: TextStyle(
                          color: Colors.grey.shade500,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  // Content
                  Text(
                    limitText(post.content, 100),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    style: TextStyle(fontSize: 15),
                  ),
                ],
              ),
            ),

            if (post.media.isNotEmpty) ...[
              const SizedBox(height: 4),
              MediaDisplay(
                media: post.media[0],
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(8),
                  bottomRight: Radius.circular(8),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
