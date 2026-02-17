import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:semesta/public/extensions/string_extension.dart';
import 'package:semesta/public/helpers/params_helper.dart';
import 'package:semesta/src/widgets/main/animated.dart';
import 'package:semesta/src/widgets/sub/animated_loader.dart';

class CustomImage extends StatelessWidget {
  final MediaSource _source;
  final double? height, width;
  final Widget? errorWidget;
  final BoxFit fit;
  final String defaultAsset;
  final bool enableFade, asIcon;
  final VoidCallback? onTap;
  const CustomImage(
    this._source, {
    super.key,
    this.height,
    this.width,
    this.errorWidget,
    this.fit = BoxFit.cover,
    this.enableFade = true,
    this.onTap,
    this.defaultAsset = 'default.png',
    this.asIcon = true,
  });

  @override
  Widget build(BuildContext context) {
    if (_source.path.isEmpty) {
      return errorWidget ??
          Animated(
            onTap: onTap,
            child: Container(
              height: height,
              width: width,
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Image.asset(defaultAsset.toAsset(asIcon), fit: fit),
            ),
          );
    }

    return Animated(
      onTap: onTap,
      child: switch (_source.type) {
        MediaSourceType.network => CachedNetworkImage(
          imageUrl: _source.path,
          height: height,
          width: width,
          fit: fit,
          placeholder: (_, str) => Center(
            child: SizedBox(
              height: 24,
              width: 24,
              child: AnimatedLoader(bold: 1.8),
            ),
          ),
          errorWidget: (_, str, err) {
            return errorWidget ??
                const Icon(Icons.broken_image, color: Colors.grey);
          },
          fadeInDuration: enableFade
              ? const Duration(milliseconds: 300)
              : Duration.zero,
          fadeOutDuration: enableFade
              ? const Duration(milliseconds: 200)
              : Duration.zero,
        ),
        MediaSourceType.file => Image.file(
          File(_source.path),
          fit: fit,
          height: height,
          width: width,
        ),
        MediaSourceType.asset => Image.asset(
          _source.path,
          height: height,
          width: width,
          fit: fit,
        ),
      },
    );
  }
}
