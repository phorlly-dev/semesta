import 'package:flutter/material.dart';
import 'package:semesta/app/controllers/highlight_controller.dart';
import 'package:semesta/app/models/feed.dart';
import 'package:semesta/public/extensions/context_extension.dart';
import 'package:semesta/public/extensions/date_time_extension.dart';
import 'package:semesta/public/helpers/generic_helper.dart';
import 'package:semesta/public/helpers/params_helper.dart';
import 'package:semesta/src/components/composer/post_editor.dart';
import 'package:semesta/src/components/global/text_expandable.dart';
import 'package:semesta/src/components/info/data_helper.dart';
import 'package:semesta/src/widgets/main/imaged_render.dart';
import 'package:semesta/src/widgets/sub/animated_avatar.dart';
import 'package:semesta/src/widgets/sub/animated_loader.dart';
import 'package:semesta/src/widgets/sub/direction_x.dart';
import 'package:semesta/src/widgets/sub/direction_y.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

class RepostEditor extends StatelessWidget {
  final Feed _post;
  final String avatar;
  final String? label;
  final List<AssetEntity> assets;
  final HighlightController? input;
  final ValueChanged<int>? onRemove;
  final ValueChanged<String>? onChanged;
  const RepostEditor(
    this._post, {
    super.key,
    this.label,
    this.input,
    this.onRemove,
    this.onChanged,
    this.avatar = '',
    this.assets = const [],
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: pctrl.loadReference(_post),
      builder: (_, snapshot) {
        if (!snapshot.hasData) return const AnimatedLoader(cupertino: true);

        final state = snapshot.data!;
        final actor = state.author;
        final parent = state.feed;
        return PostEditor(
          avatar: avatar,
          input: input,
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
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                children: [
                  DirectionX(
                    children: [
                      AnimatedAvatar(
                        MediaSource.network(actor.media.url),
                        size: 32,
                        padding: EdgeInsets.only(top: 2),
                      ),

                      const SizedBox(width: 8),
                      Wrap(
                        children: [
                          DisplayName(actor.name),

                          const SizedBox(width: 6),
                          Username(actor.uname),
                        ],
                      ),

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

                  const SizedBox(height: 8),

                  // input
                  TextExpandable(
                    parent.title,
                    textColor: context.secondaryColor,
                  ),
                ],
              ),

              if (parent.media.isNotEmpty) ...[
                const SizedBox(height: 4),
                ImagedRender(
                  parent.media[0],
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(8),
                    bottomRight: Radius.circular(8),
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}
