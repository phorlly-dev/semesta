import 'package:flutter/material.dart';

class ImagedCropper extends StatefulWidget {
  final ImageProvider image;
  final Size crop;
  final bool circle;
  const ImagedCropper({
    super.key,
    required this.image,
    required this.crop,
    required this.circle,
  });

  @override
  State<ImagedCropper> createState() => _ImagedCropperState();
}

class _ImagedCropperState extends State<ImagedCropper> {
  final _controller = TransformationController();

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // dark background
        Container(color: Colors.black),

        // movable image
        InteractiveViewer(
          transformationController: _controller,
          minScale: 1,
          maxScale: 4,
          boundaryMargin: const EdgeInsets.all(double.infinity),
          child: Image(image: widget.image, fit: BoxFit.cover),
        ),

        // crop mask
        IgnorePointer(
          child: Center(
            child: widget.circle
                ? ClipOval(child: _mask)
                : ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: _mask,
                  ),
          ),
        ),
      ],
    );
  }

  Widget get _mask => Container(
    width: widget.crop.width,
    height: widget.crop.height,
    decoration: BoxDecoration(color: Colors.black.withValues(alpha: 0.4)),
  );
}
