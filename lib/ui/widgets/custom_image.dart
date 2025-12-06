import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:semesta/ui/widgets/animated.dart';
import 'package:semesta/ui/widgets/loader.dart';

class CustomImage extends StatelessWidget {
  const CustomImage({
    super.key,
    required this.image,
    this.height,
    this.width,
    this.errorWidget,
    this.fit = BoxFit.cover,
    this.borderRadius,
    this.enableFade = true,
    this.spaceX = 0,
    this.spaceY = 0,
    this.onTap,
  });

  final String image;
  final double? height, width;
  final double spaceX, spaceY;
  final Widget? errorWidget;
  final BoxFit fit;
  final BorderRadius? borderRadius;
  final bool enableFade;
  final VoidCallback? onTap;

  bool get _isNetwork =>
      image.startsWith('http://') || image.startsWith('https://');

  @override
  Widget build(BuildContext context) {
    if (image.isEmpty) {
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

    final url = _isNetwork
        ? CachedNetworkImage(
            imageUrl: image,
            height: height,
            width: width,
            fit: fit,
            placeholder: (ctx, str) => Center(
              child: SizedBox(height: 24, width: 24, child: Loader(bold: 1.8)),
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
        : Image.asset(image, height: height, width: width, fit: fit);

    // Apply rounded corners (optional)
    return Animated(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: spaceX, vertical: spaceY),
        child: ClipRRect(
          borderRadius: borderRadius ?? BorderRadius.zero,
          child: url,
        ),
      ),
    );
  }
}
