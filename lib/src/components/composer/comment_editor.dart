import 'package:flutter/material.dart';
import 'package:semesta/app/models/author.dart';
import 'package:semesta/app/models/feed.dart';
import 'package:semesta/public/extensions/extension.dart';
import 'package:semesta/public/utils/comment_connector.dart';
import 'package:semesta/src/components/composer/post_editor.dart';
import 'package:semesta/src/components/user/user_info.dart';
import 'package:semesta/src/widgets/main/media_display.dart';
import 'package:semesta/src/widgets/sub/avatar_animation.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

class CommentEditor extends StatelessWidget {
  final String avatar;
  final String? label;
  final Feed post;
  final Author actor;
  final TextEditingController content;
  final ValueChanged<int>? onRemove;
  final ValueChanged<String>? onChanged;
  final List<AssetEntity> assets;
  const CommentEditor({
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

    // In a real scenario, these offsets would likely be calculated
    // via GlobalKeys or based on the list index.
    final start = Offset(20, 46); // Relative to Stack top-left
    final end = Offset(20, 362);

    return Column(
      children: [
        Stack(
          children: [
            Positioned.fill(
              child: CustomPaint(
                painter: CommentConnector(
                  startPoint: start,
                  endPoint: end,
                  lineColor: dividerColor,
                ),
              ),
            ),

            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // LEFT GUTTER (avatar + connector)
                AvatarAnimation(actor.avatar, size: 40),

                SizedBox(width: 12),

                // FULL POST PREVIEW (not just text!)
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          DisplayName(actor.name, maxChars: 56),

                          const Spacer(),
                          Text(
                            post.createdAt.toAgo,
                            style: TextStyle(
                              color: Colors.grey.shade500,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),

                      Text(
                        post.title.limitText(100),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: TextStyle(fontSize: 15),
                      ),

                      if (post.media.isNotEmpty) ...[
                        const SizedBox(height: 6),
                        MediaDisplay(
                          post.media[0],
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ],

                      const SizedBox(height: 8),
                      Row(
                        spacing: 4,
                        children: [
                          Text('Reply to'),
                          Username(
                            actor.uname,
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
          ],
        ),

        const SizedBox(height: 8),
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
