import 'package:flutter/material.dart';
import 'package:semesta/public/helpers/params_helper.dart';
import 'package:semesta/src/widgets/main/custom_image.dart';

class CoverEditable extends StatelessWidget {
  final VoidCallback? onTap;
  final MediaSource _source;
  const CoverEditable(this._source, {super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      customBorder: const CircleBorder(),
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Banner image
          ClipRRect(
            child: CustomImage(
              _source,
              defaultAsset: 'bg-cover.jpg',
              asIcon: false,
              width: double.infinity,
              height: 160,
            ),
          ),

          // Dim overlay
          Container(color: Colors.black.withValues(alpha: 0.25)),

          // Camera button
          Center(
            child: Material(
              shape: const CircleBorder(),
              color: Colors.black.withAlpha(40),
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Icon(
                  Icons.camera_alt_outlined,
                  color: Colors.white,
                  size: 32,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
