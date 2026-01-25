import 'package:flutter/material.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

class MediaPreview extends StatelessWidget {
  final List<AssetEntity> _assets;
  final ValueChanged<int>? onRemove;
  const MediaPreview(this._assets, {super.key, this.onRemove});

  @override
  Widget build(BuildContext context) {
    if (_assets.isEmpty) return const SizedBox.shrink();

    if (_assets.length == 1) {
      return _buildSingle(context);
    } else if (_assets.length == 2) {
      return _buildMultiple(context);
    } else {
      return _buildMultiple(context);
    }
  }

  // === One image full preview ===
  Widget _buildSingle(BuildContext context) {
    final asset = _assets.first;
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Stack(
        children: [
          AspectRatio(
            aspectRatio: .76,
            child: AssetEntityImage(asset, fit: BoxFit.cover),
          ),

          // Show play icon overlay if it's a video
          if (asset.type == AssetType.video)
            const Positioned.fill(
              child: Align(
                alignment: Alignment.center,
                child: Icon(
                  Icons.play_circle_fill,
                  color: Colors.white,
                  size: 42,
                ),
              ),
            ),

          if (onRemove != null)
            Positioned(
              top: 8,
              right: 8,
              child: _removeButton(() => onRemove?.call(0)),
            ),
        ],
      ),
    );
  }

  // === Multiple images, horizontal scroll ===
  Widget _buildMultiple(BuildContext context) {
    return SizedBox(
      height: 210,
      child: ListView.separated(
        padding: EdgeInsets.only(left: 58, top: 6, bottom: 6),
        scrollDirection: Axis.horizontal,
        itemCount: _assets.length,
        separatorBuilder: (ctx, idx) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final asset = _assets[index];
          return ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Stack(
              children: [
                AssetEntityImage(asset, fit: BoxFit.cover),

                // Show play icon overlay if it's a video
                if (asset.type == AssetType.video)
                  const Positioned.fill(
                    child: Align(
                      alignment: Alignment.center,
                      child: Icon(
                        Icons.play_circle_fill,
                        color: Colors.white,
                        size: 42,
                      ),
                    ),
                  ),

                if (onRemove != null)
                  Positioned(
                    top: 6,
                    right: 6,
                    child: _removeButton(() => onRemove?.call(index)),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _removeButton(VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 28,
        height: 28,
        decoration: const BoxDecoration(
          color: Colors.black87,
          shape: BoxShape.circle,
        ),
        child: const Icon(Icons.close, color: Colors.white, size: 20),
      ),
    );
  }
}
