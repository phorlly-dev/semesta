import 'package:flutter/material.dart';
import 'package:semesta/app/controllers/highlight_controller.dart';
import 'package:semesta/app/models/author.dart';
import 'package:semesta/app/models/feed.dart';
import 'package:semesta/src/components/composer/post_editor.dart';
import 'package:semesta/src/components/composer/comment_editor.dart';
import 'package:semesta/src/components/composer/repost_editor.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

class PostComposer extends StatelessWidget {
  final Feed? parent;
  final bool isReply;
  final String? label;
  final Author _author;
  final List<AssetEntity> assets;
  final ValueChanged<int>? onRemove;
  final HighlightController? input;
  final ValueChanged<String>? onChanged;
  const PostComposer(
    this._author, {
    super.key,
    this.label,
    this.parent,
    this.onChanged,
    this.assets = const [],
    this.input,
    this.isReply = false,
    this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final hasParent = parent != null;
    final avatar = _author.media.url;

    return ListView(
      shrinkWrap: true,
      padding: EdgeInsets.all(12),
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      children: [
        if (hasParent && isReply)
          CommentEditor(
            parent!,
            avatar: avatar,
            input: input,
            label: label,
            onChanged: onChanged,
            assets: assets,
            onRemove: onRemove,
          )
        else if (hasParent)
          RepostEditor(
            parent!,
            avatar: avatar,
            input: input,
            label: label,
            onChanged: onChanged,
            assets: assets,
            onRemove: onRemove,
          )
        else
          PostEditor(
            avatar: avatar,
            onChanged: onChanged,
            input: input,
            assets: assets,
            label: label,
            onRemove: onRemove,
          ),
      ],
    );
  }
}
