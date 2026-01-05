import 'package:flutter/material.dart';
import 'package:semesta/app/utils/type_def.dart';
import 'package:semesta/core/models/feed.dart';
import 'package:semesta/core/views/audit_view.dart';
import 'package:semesta/ui/components/posts/post_editor.dart';
import 'package:semesta/ui/components/posts/reply_editor.dart';
import 'package:semesta/ui/components/posts/repost_editor.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

class PostComposer extends StatelessWidget {
  final List<AssetEntity> assets;
  final TextEditingController content;
  final Feed? parent;
  final StatusView audit;
  final String? label;
  final bool isReply;
  final PropsCallback<String, void>? onChanged;
  final PropsCallback<int, void>? onRemove;
  const PostComposer({
    super.key,
    required this.assets,
    required this.content,
    this.onChanged,
    this.label,
    required this.isReply,
    required this.onRemove,
    this.parent,
    required this.audit,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Column(
          children: [
            if ((parent != null && audit.actor != null) && isReply)
              ReplyEditor(
                avatar: audit.author.avatar,
                content: content,
                post: parent!,
                label: label,
                onChanged: onChanged,
                assets: assets,
                onRemove: onRemove,
                actor: audit.actor!,
              )
            else if (parent != null && audit.actor != null)
              RepostEditor(
                avatar: audit.author.avatar,
                content: content,
                post: parent!,
                label: label,
                onChanged: onChanged,
                assets: assets,
                onRemove: onRemove,
                actor: audit.actor!,
              )
            else
              PostEditor(
                avatar: audit.author.avatar,
                onChanged: onChanged,
                content: content,
                assets: assets,
                label: label,
                onRemove: onRemove,
              ),
          ],
        ),
      ),
    );
  }
}
