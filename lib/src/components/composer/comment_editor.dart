import 'package:flutter/material.dart';
import 'package:semesta/app/models/author.dart';
import 'package:semesta/app/models/feed.dart';
import 'package:semesta/public/extensions/context_extension.dart';
import 'package:semesta/public/extensions/date_time_extension.dart';
import 'package:semesta/public/extensions/string_extension.dart';
import 'package:semesta/public/utils/comment_connector.dart';
import 'package:semesta/public/helpers/params_helper.dart';
import 'package:semesta/src/components/composer/post_editor.dart';
import 'package:semesta/src/components/user/user_info.dart';
import 'package:semesta/src/widgets/main/imaged_render.dart';
import 'package:semesta/src/widgets/sub/animated_avatar.dart';
import 'package:semesta/src/widgets/sub/direction_x.dart';
import 'package:semesta/src/widgets/sub/direction_y.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

class CommentEditor extends StatelessWidget {
  final String avatar;
  final String? label;
  final Feed _post;
  final Author _actor;
  final TextEditingController? content;
  final ValueChanged<int>? onRemove;
  final ValueChanged<String>? onChanged;
  final List<AssetEntity> assets;
  final double start, end;
  const CommentEditor(
    this._post,
    this._actor, {
    super.key,
    this.label,
    this.onChanged,
    this.onRemove,
    this.avatar = '',
    this.content,
    this.assets = const [],
    this.start = 44,
    this.end = 370,
  });

  @override
  Widget build(BuildContext context) {
    return DirectionY(
      children: [
        Stack(
          children: [
            Positioned.fill(
              child: CustomPaint(
                painter: CommentConnector(
                  startPoint: Offset(16, start),
                  endPoint: Offset(16, _post.media.isEmpty ? 78 : end),
                  lineColor: context.dividerColor,
                ),
              ),
            ),

            DirectionX(
              children: [
                // LEFT GUTTER (avatar + connector)
                AvatarAnimation(
                  MediaSource.network(_actor.avatar),
                  padding: EdgeInsets.only(top: 2),
                ),

                SizedBox(width: 8),

                // FULL POST PREVIEW (not just text!)
                Expanded(
                  child: DirectionY(
                    children: [
                      DirectionX(
                        children: [
                          DisplayName(_actor.name, maxChars: 56),

                          // const SizedBox(width: 6),
                          // Username(actor.uname),
                          const Spacer(),
                          Text(
                            _post.createdAt.toAgo,
                            style: TextStyle(
                              color: Colors.grey.shade500,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),

                      Text(
                        _post.title.limitText(100),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: TextStyle(fontSize: 15),
                      ),

                      if (_post.media.isNotEmpty) ...[
                        const SizedBox(height: 6),
                        ImagedRender(
                          _post.media[0],
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ],

                      const SizedBox(height: 8),
                      DirectionX(
                        spacing: 4,
                        children: [
                          Text('Reply to', style: TextStyle(fontSize: 16)),
                          Username(
                            _actor.uname,
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

        const SizedBox(height: 6),
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
