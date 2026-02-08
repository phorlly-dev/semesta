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
  final StatusView _audit;
  final List<AssetEntity> assets;
  final ValueChanged<int>? onRemove;
  final TextEditingController? content;
  final ValueChanged<String>? onChanged;
  const PostComposer(
    this._audit, {
    super.key,
    this.label,
    this.parent,
    this.onChanged,
    this.assets = const [],
    this.content,
    this.isReply = false,
    this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final hasParent = parent != null && _audit.actor != null;
    final avatar = _audit.author.avatar;

    return SingleChildScrollView(
      padding: EdgeInsets.all(12),
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      child: hasParent && isReply
          ? CommentEditor(
              parent!,
              _audit.actor!,
              avatar: avatar,
              content: content,
              label: label,
              onChanged: onChanged,
              assets: assets,
              onRemove: onRemove,
            )
          : hasParent
          ? RepostEditor(
              parent!,
              _audit.actor!,
              avatar: avatar,
              content: content,
              label: label,
              onChanged: onChanged,
              assets: assets,
              onRemove: onRemove,
            )
          : PostEditor(
              avatar: avatar,
              onChanged: onChanged,
              content: content,
              assets: assets,
              label: label,
              onRemove: onRemove,
            ),
    );
  }
}
