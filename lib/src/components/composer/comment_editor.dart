import 'package:flutter/material.dart';
import 'package:semesta/app/controllers/highlight_controller.dart';
import 'package:semesta/app/models/feed.dart';
import 'package:semesta/public/extensions/context_extension.dart';
import 'package:semesta/public/extensions/date_time_extension.dart';
import 'package:semesta/public/helpers/generic_helper.dart';
import 'package:semesta/public/utils/connector.dart';
import 'package:semesta/public/helpers/params_helper.dart';
import 'package:semesta/src/components/composer/post_editor.dart';
import 'package:semesta/src/components/global/text_expandable.dart';
import 'package:semesta/src/components/info/data_helper.dart';
import 'package:semesta/src/components/info/referenced_to_post.dart';
import 'package:semesta/src/widgets/main/imaged_render.dart';
import 'package:semesta/src/widgets/sub/animated_avatar.dart';
import 'package:semesta/src/widgets/sub/animated_loader.dart';
import 'package:semesta/src/widgets/sub/direction_x.dart';
import 'package:semesta/src/widgets/sub/direction_y.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

class CommentEditor extends StatelessWidget {
  final Feed _post;
  final String avatar;
  final String? label;
  final double start, end;
  final List<AssetEntity> assets;
  final HighlightController? input;
  final ValueChanged<int>? onRemove;
  final ValueChanged<String>? onChanged;
  const CommentEditor(
    this._post, {
    super.key,
    this.label,
    this.onChanged,
    this.onRemove,
    this.avatar = '',
    this.input,
    this.assets = const [],
    this.start = 46,
    this.end = 370,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: pctrl.loadReference(_post),
      builder: (_, snapshot) {
        if (!snapshot.hasData) return const AnimatedLoader(cupertino: true);

        final center = (start * .5) - 6;
        final state = snapshot.data!;
        final actor = state.author;
        final parent = state.feed;
        return DirectionY(
          children: [
            Stack(
              children: [
                Positioned.fill(
                  child: CustomPaint(
                    painter: Connector(
                      Offset(center, start),
                      Offset(center, _post.media.isEmpty ? 78 : end),
                      context.dividerColor,
                    ),
                  ),
                ),

                DirectionX(
                  children: [
                    // LEFT GUTTER (avatar + connector)
                    AnimatedAvatar(
                      MediaSource.network(actor.media.url),
                      padding: EdgeInsets.only(top: 2),
                    ),

                    const SizedBox(width: 8),

                    // FULL POST PREVIEW (not just text!)
                    Expanded(
                      child: DirectionY(
                        children: [
                          DirectionX(
                            children: [
                              DisplayName(actor.name, maxChars: 56),

                              // const SizedBox(width: 6),
                              // Username(actor.uname),
                              const Spacer(),
                              Text(
                                parent.createdAt.toAgo,
                                style: TextStyle(
                                  color: Colors.grey.shade500,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),

                          TextExpandable(
                            parent.title,
                            textColor: context.secondaryColor,
                          ),

                          if (parent.media.isNotEmpty) ...[
                            const SizedBox(height: 8),
                            ImagedRender(
                              parent.media[0],
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ],

                          const SizedBox(height: 8),
                          DisplayParent(actor.uname),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),

            PostEditor(
              avatar: avatar,
              input: input,
              label: label,
              onChanged: onChanged,
              assets: assets,
              onRemove: onRemove,
            ),
          ],
        );
      },
    );
  }
}
