import 'package:flutter/material.dart';
import 'package:semesta/app/functions/format.dart';
import 'package:semesta/app/utils/type_def.dart';
import 'package:semesta/core/models/author.dart';
import 'package:semesta/core/models/feed.dart';
import 'package:semesta/ui/widgets/media_display.dart';
import 'package:semesta/ui/components/posts/post_editor.dart';
import 'package:semesta/ui/components/users/user_info.dart';
import 'package:semesta/ui/widgets/avatar_animation.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

class ReplyEditor extends StatelessWidget {
  final String avatar;
  final String? label;
  final Feed post;
  final Author actor;
  final TextEditingController content;
  final PropsCallback<String, void>? onChanged;
  final PropsCallback<int, void>? onRemove;
  final List<AssetEntity> assets;
  const ReplyEditor({
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
    final dividerColor = Theme.of(context).dividerColor.withValues(alpha: 0.5);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // LEFT GUTTER (avatar + connector)
            SizedBox(
              width: 56,
              child: Column(
                children: [
                  AvatarAnimation(imageUrl: actor.avatar, size: 40),
                  Container(width: 2, color: dividerColor, height: 320),
                ],
              ),
            ),

            // FULL POST PREVIEW (not just text!)
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
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

                  Text(
                    limitText(post.content, 100),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),

                  if (post.media.isNotEmpty) ...[
                    const SizedBox(height: 6),
                    MediaDisplay(
                      media: post.media[0],
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ],

                  const SizedBox(height: 12),
                  Row(
                    spacing: 4,
                    children: [
                      Text(
                        'Reply to',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      Username(
                        data: actor.uname,
                        color: Colors.blueAccent,
                        maxChars: 50,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),

        PostEditor(
          avatar: avatar,
          content: content,
          label: label,
          onChanged: onChanged,
          assets: assets,
          onRemove: onRemove,
        ),
      ],
    );
  }
}
