import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class CustomImage extends StatelessWidget {
  const CustomImage({
    super.key,
    required this.imageUrl,
    this.height,
    this.width,
    this.placeholder,
    this.errorWidget,
    this.fit = BoxFit.cover,
    this.borderRadius,
    this.enableFade = true,
  });

  final String imageUrl;
  final double? height;
  final double? width;
  final Widget? placeholder;
  final Widget? errorWidget;
  final BoxFit fit;
  final BorderRadius? borderRadius;
  final bool enableFade;

  bool get _isNetwork =>
      imageUrl.startsWith('http://') || imageUrl.startsWith('https://');

  @override
  Widget build(BuildContext context) {
    if (imageUrl.isEmpty) {
      return errorWidget ??
          Container(
            height: height,
            width: width,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: borderRadius ?? BorderRadius.circular(8),
            ),
            child: const Icon(Icons.image_not_supported, color: Colors.grey),
          );
    }

    final image = _isNetwork
        ? CachedNetworkImage(
            imageUrl: imageUrl,
            height: height,
            width: width,
            fit: fit,
            placeholder: (ctx, str) =>
                placeholder ??
                Center(
                  child: SizedBox(
                    height: 20,
                    width: 20,
                    child: const CircularProgressIndicator(strokeWidth: 2),
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
        : Image.asset(imageUrl, height: height, width: width, fit: fit);

    // Apply rounded corners (optional)
    return ClipRRect(
      borderRadius: borderRadius ?? BorderRadius.circular(8),
      child: image,
    );
  }
}
