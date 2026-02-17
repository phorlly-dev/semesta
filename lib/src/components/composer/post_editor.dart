import 'package:flutter/material.dart';
import 'package:semesta/app/controllers/highlight_controller.dart';
import 'package:semesta/public/helpers/params_helper.dart';
import 'package:semesta/src/components/global/media_preview.dart';
import 'package:semesta/src/widgets/sub/animated_avatar.dart';
import 'package:semesta/src/widgets/sub/direction_x.dart';
import 'package:semesta/src/widgets/sub/direction_y.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

class PostEditor extends StatelessWidget {
  final Widget? bottom;
  final String avatar;
  final String? label;
  final List<AssetEntity> assets;
  final HighlightController? input;
  final ValueChanged<int>? onRemove;
  final ValueChanged<String>? onChanged;
  const PostEditor({
    super.key,
    this.input,
    this.label,
    this.bottom,
    this.onRemove,
    this.onChanged,
    this.avatar = '',
    this.assets = const [],
  });

  @override
  Widget build(BuildContext context) {
    return DirectionY(
      children: [
        DirectionX(
          children: [
            AnimatedAvatar(MediaSource.network(avatar)),
            const SizedBox(width: 8),

            Expanded(
              child: DirectionY(
                children: [
                  const SizedBox(height: 4),
                  TextField(
                    controller: input,
                    autofocus: true,
                    maxLines: null, // grow downward
                    keyboardType: TextInputType.multiline,
                    decoration: InputDecoration(
                      hintText: label ?? "What's new?",
                      border: InputBorder.none,
                      isCollapsed: true, // 🔥 prevents vertical jump
                    ),
                    style: TextStyle(fontSize: 16, height: 1.4),
                    onChanged: onChanged,
                  ),

                  if (assets.length == 1) ...[
                    const SizedBox(height: 8),
                    MediaPreview(assets, onRemove: onRemove),
                  ],
                ],
              ),
            ),
          ],
        ),

        // ---- Media preview ----
        if (assets.length > 1) MediaPreview(assets, onRemove: onRemove),

        if (bottom != null) ...[
          if (assets.isNotEmpty) const SizedBox(height: 6),
          Padding(padding: const EdgeInsets.only(left: 44), child: bottom!),
        ],
      ],
    );
  }
}
