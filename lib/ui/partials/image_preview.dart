import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:semesta/app/functions/option_modal.dart';
import 'package:semesta/ui/components/global/_layout_page.dart';
import 'package:semesta/ui/components/global/nav_bar_layer.dart';

class ImagePreview extends StatefulWidget {
  final List<String> images;
  final int initialIndex;

  const ImagePreview({super.key, required this.images, this.initialIndex = 0});

  @override
  State<ImagePreview> createState() => _ImagePreviewState();
}

class _ImagePreviewState extends State<ImagePreview> {
  late final PageController _pageController;
  double _dragOffset = 0;
  int currentIndex = 0;
  bool toggle = true;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: widget.initialIndex);
    currentIndex = widget.initialIndex;
  }

  void _onVerticalDragUpdate(DragUpdateDetails details) {
    setState(() {
      _dragOffset += details.delta.dy;
    });
  }

  void _onVerticalDragEnd(DragEndDetails details) {
    if (_dragOffset.abs() > 120) {
      Navigator.pop(context);
    } else {
      setState(() => _dragOffset = 0);
    }
  }

  @override
  Widget build(BuildContext context) {
    final options = OptionModal(context);
    final opacity = (1.0 - (_dragOffset.abs() / 300)).clamp(0.3, 1.0);

    return LayoutPage(
      header: toggle
          ? NavBarLayer(
              start: IconButton(
                onPressed: () => context.pop(),
                icon: Icon(Icons.close_rounded, color: Colors.white),
              ),
              end: IconButton(
                onPressed: options.imageOptions,
                icon: Icon(Icons.more_horiz_rounded, color: Colors.white),
              ),
              bgColor: Colors.transparent,
            )
          : NavBarLayer(bgColor: Colors.transparent, start: SizedBox.shrink()),
      bgColor: Colors.black.withValues(alpha: opacity),
      content: GestureDetector(
        onVerticalDragUpdate: _onVerticalDragUpdate,
        onVerticalDragEnd: _onVerticalDragEnd,
        onTap: () => setState(() => toggle = !toggle),
        onLongPress: options.imageOptions,
        child: Stack(
          children: [
            Transform.translate(
              offset: Offset(0, _dragOffset),
              child: PhotoViewGallery.builder(
                pageController: _pageController,
                scrollPhysics: const BouncingScrollPhysics(),
                backgroundDecoration: const BoxDecoration(
                  color: Colors.transparent,
                ),
                itemCount: widget.images.length,
                builder: (context, index) => PhotoViewGalleryPageOptions(
                  imageProvider: NetworkImage(widget.images[index]),
                  minScale: PhotoViewComputedScale.contained,
                  maxScale: PhotoViewComputedScale.covered * 2,
                  heroAttributes: PhotoViewHeroAttributes(
                    tag: widget.images[index],
                  ),
                ),
                onPageChanged: (i) => setState(() => currentIndex = i),
              ),
            ),

            // Index indicator (optional)
            if (widget.images.length > 1)
              Positioned(
                bottom: 24,
                left: 0,
                right: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    widget.images.length,
                    (index) => Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: index == currentIndex
                            ? Colors.white
                            : Colors.white38,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}
