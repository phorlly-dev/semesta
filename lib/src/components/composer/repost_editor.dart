import 'package:flutter/material.dart';
import 'package:semesta/app/models/author.dart';
import 'package:semesta/app/models/feed.dart';
import 'package:semesta/public/extensions/extension.dart';
import 'package:semesta/src/components/composer/post_editor.dart';
import 'package:semesta/src/components/user/user_info.dart';
import 'package:semesta/src/widgets/main/media_display.dart';
import 'package:semesta/src/widgets/sub/avatar_animation.dart';
import 'package:semesta/src/widgets/sub/direction_x.dart';
import 'package:semesta/src/widgets/sub/direction_y.dart';
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
      bottom: DirectionY(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey.shade300),
        ),
        children: [
          DirectionY(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            children: [
              DirectionX(
                children: [
                  AvatarAnimation(
                    actor.avatar,
                    size: 32,
                    padding: EdgeInsets.only(top: 2),
                  ),

                  const SizedBox(width: 8),
                  DisplayName(actor.name),

                  const SizedBox(width: 6),
                  Username(actor.uname),

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

              const SizedBox(height: 8),

              // Content
              Text(
                post.title.limitText(100),
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
                style: TextStyle(fontSize: 15),
              ),
            ],
          ),

          if (post.media.isNotEmpty) ...[
            const SizedBox(height: 4),
            MediaDisplay(
              post.media[0],
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(8),
                bottomRight: Radius.circular(8),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
