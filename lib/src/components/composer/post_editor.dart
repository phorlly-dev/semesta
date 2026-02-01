import 'package:flutter/material.dart';
import 'package:semesta/public/utils/params.dart';
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
  final TextEditingController? content;
  final ValueChanged<String>? onChanged;
  final ValueChanged<int>? onRemove;
  const PostEditor({
    super.key,
    this.avatar = '',
    this.onChanged,
    this.content,
    this.label,
    this.bottom,
    this.assets = const [],
    this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return DirectionY(
      children: [
        DirectionX(
          children: [
            AvatarAnimation(
              MediaSource.network(avatar),
              padding: EdgeInsets.only(top: 2),
            ),

            const SizedBox(width: 8),

            Expanded(
              child: DirectionY(
                children: [
                  TextField(
                    controller: content,
                    autofocus: true,
                    maxLines: null, // grow downward
                    keyboardType: TextInputType.multiline,
                    decoration: InputDecoration(
                      hintText: label ?? "What's new?",
                      border: InputBorder.none,
                      isCollapsed: true, // 🔥 prevents vertical jump
                    ),
                    style: const TextStyle(
                      fontSize: 16,
                      height: 1.4, // smoother line growth
                    ),
                    onChanged: onChanged,
                  ),

                  if (assets.length == 1) ...[
                    SizedBox(height: 8),
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
          if (assets.isNotEmpty) SizedBox(height: 6),
          Padding(padding: const EdgeInsets.only(left: 44), child: bottom!),
        ],
      ],
    );
  }
}
