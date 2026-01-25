import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:semesta/src/widgets/main/animated.dart';
import 'package:semesta/src/widgets/sub/loading_animated.dart';

class CustomImage extends StatelessWidget {
  const CustomImage(
    this._image, {
    super.key,
    this.height,
    this.width,
    this.errorWidget,
    this.fit = BoxFit.cover,
    this.enableFade = true,
    this.spaceX = 0,
    this.spaceY = 0,
    this.onTap,
  });

  final String _image;
  final double? height, width;
  final double spaceX, spaceY;
  final Widget? errorWidget;
  final BoxFit fit;
  final bool enableFade;
  final VoidCallback? onTap;

  bool get _isNetwork {
    return _image.startsWith('http://') || _image.startsWith('https://');
  }

  @override
  Widget build(BuildContext context) {
    if (_image.isEmpty) {
      return errorWidget ??
          Container(
            height: height,
            width: width,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.image_not_supported, color: Colors.grey),
          );
    }

    final url = _isNetwork
        ? CachedNetworkImage(
            imageUrl: _image,
            height: height,
            width: width,
            fit: fit,
            placeholder: (ctx, str) => Center(
              child: SizedBox(
                height: 24,
                width: 24,
                child: LoadingAnimated(bold: 1.8),
              ),
            ),
            errorWidget: (ctx, str, err) =>
                errorWidget ??
                const Icon(Icons.broken_image, color: Colors.grey),
            fadeInDuration: enableFade
                ? const Duration(milliseconds: 300)
                : Duration.zero,
            fadeOutDuration: enableFade
                ? const Duration(milliseconds: 200)
                : Duration.zero,
          )
        : Image.asset(_image, height: height, width: width, fit: fit);

    // Apply rounded corners (optional)
    return Animated(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: spaceX, vertical: spaceY),
        child: url,
      ),
    );
  }
}
