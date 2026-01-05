import 'package:flutter/material.dart';
import 'package:semesta/app/utils/type_def.dart';
import 'package:semesta/ui/widgets/avatar_animation.dart';
import 'package:semesta/ui/components/globals/media_preview.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

class PostEditor extends StatelessWidget {
  final Widget? bottom;
  final String avatar;
  final String? label;
  final List<AssetEntity> assets;
  final TextEditingController content;
  final PropsCallback<String, void>? onChanged;
  final PropsCallback<int, void>? onRemove;
  const PostEditor({
    super.key,
    required this.avatar,
    this.onChanged,
    required this.content,
    this.label,
    this.bottom,
    required this.assets,
    this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start, // 🔥 important
          children: [
            AvatarAnimation(imageUrl: avatar, size: 42),

            const SizedBox(width: 14),

            Expanded(
              child: Column(
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
                ],
              ),
            ),
          ],
        ),

        // ---- Media preview ----
        MediaPreview(assets: assets, onRemove: onRemove),

        if (bottom != null) ...[
          Padding(
            padding: const EdgeInsets.only(left: 58, right: 8),
            child: bottom!,
          ),
        ],
      ],
    );
  }
}
