import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:semesta/core/models/post_model.dart';
import 'package:semesta/ui/components/posts/post_preview.dart';
import 'package:semesta/ui/widgets/avatar_animation.dart';
import 'package:semesta/ui/widgets/media_preview.dart';
import 'package:semesta/ui/widgets/reply_connector.dart';
import 'package:semesta/ui/widgets/text_grouped.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

class PostComposer extends StatelessWidget {
  final List<AssetEntity> assets;
  final TextEditingController content;
  final String avatar, name, username;
  final String? label;
  final PostModel? parentPost;
  final bool isReply;
  final void Function(String value)? onChanged;
  final void Function(int index) onRemove;

  const PostComposer({
    super.key,
    required this.assets,
    required this.content,
    required this.avatar,
    required this.name,
    required this.username,
    this.onChanged,
    this.label,
    this.parentPost,
    required this.isReply,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListView(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      children: [
        SizedBox(height: 12),

        if (parentPost != null && isReply)
          ReplyConnector(
            parent: PostPreview(post: parentPost!),
            child: ListTile(
              leading: AvatarAnimation(imageUrl: avatar),
              title: TextGrouped(
                first: 'Replying to',
                second: '@${parentPost?.username}',
              ),
            ),
          )
        else if (parentPost != null)
          ListTile(
            leading: AvatarAnimation(imageUrl: avatar),
            title: PostPreview(post: parentPost!, isRepost: true),
          )
        else
          ListTile(
            leading: AvatarAnimation(imageUrl: avatar),
            title: TextGrouped(
              first: name,
              second: '@$username',
              secondColor: theme.colorScheme.secondary,
            ),
          ),

        Padding(
          padding: EdgeInsets.only(left: .18.sw),
          child: TextField(
            decoration: InputDecoration(
              hintText: label ?? "What's new?",
              border: InputBorder.none,
            ),
            autofocus: true,
            maxLines: null,
            controller: content,
            keyboardType: TextInputType.multiline,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            onChanged: onChanged,
          ),
        ),

        // ---- Media preview ----
        MediaPreview(assets: assets, onRemove: onRemove),
      ],
    );
  }
}
