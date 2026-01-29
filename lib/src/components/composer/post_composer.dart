import 'package:flutter/material.dart';
import 'package:semesta/app/models/feed.dart';
import 'package:semesta/public/helpers/audit_view.dart';
import 'package:semesta/src/components/composer/post_editor.dart';
import 'package:semesta/src/components/composer/comment_editor.dart';
import 'package:semesta/src/components/composer/repost_editor.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

class PostComposer extends StatelessWidget {
  final Feed? parent;
  final bool isReply;
  final String? label;
  final StatusView audit;
  final List<AssetEntity> assets;
  final ValueChanged<int>? onRemove;
  final TextEditingController content;
  final ValueChanged<String>? onChanged;
  const PostComposer({
    super.key,
    this.label,
    this.parent,
    this.onChanged,
    required this.audit,
    required this.assets,
    required this.content,
    required this.isReply,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final hasParent = parent != null && audit.actor != null;
    return SingleChildScrollView(
      padding: EdgeInsets.all(12),
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      child: hasParent && isReply
          ? CommentEditor(
              avatar: audit.author.avatar,
              content: content,
              post: parent!,
              label: label,
              onChanged: onChanged,
              assets: assets,
              onRemove: onRemove,
              actor: audit.actor!,
            )
          : hasParent
          ? RepostEditor(
              avatar: audit.author.avatar,
              content: content,
              post: parent!,
              label: label,
              onChanged: onChanged,
              assets: assets,
              onRemove: onRemove,
              actor: audit.actor!,
            )
          : PostEditor(
              avatar: audit.author.avatar,
              onChanged: onChanged,
              content: content,
              assets: assets,
              label: label,
              onRemove: onRemove,
            ),
    );
  }
}
