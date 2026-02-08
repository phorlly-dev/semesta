import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:semesta/public/extensions/context_extension.dart';
import 'package:semesta/public/extensions/controller_extension.dart';
import 'package:semesta/public/helpers/generic_helper.dart';
import 'package:semesta/public/utils/type_def.dart';
import 'package:semesta/src/components/layout/_page.dart';
import 'package:semesta/src/components/post/actions_bar.dart';
import 'package:semesta/src/widgets/sub/direction_x.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';

class ImagedPreview extends StatefulWidget {
  final String id;
  final int initIndex;
  final AsList _images, media;
  const ImagedPreview(
    this._images, {
    super.key,
    this.id = '',
    this.initIndex = 0,
    this.media = const [],
  });

  @override
  State<ImagedPreview> createState() => _ImagedPreviewState();
}

class _ImagedPreviewState extends State<ImagedPreview> {
  late final PageController _pageController;
  double _dragOffset = 0;
  int _currentIndex = 0;
  bool _toggle = true;
  AsList get _media => widget._images;
  late ProgressDialog _pd;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initIndex;
    _pd = ProgressDialog(context: context);
    _pageController = PageController(initialPage: _currentIndex);
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
    final opacity = (1.0 - (_dragOffset.abs() / 300)).clamp(0.3, 1.0);

    return AnnotatedRegion(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light, // Android
        statusBarBrightness: Brightness.dark, // iOS
      ),
      child: PageLayout(
        color: Colors.black.withValues(alpha: opacity),
        content: GestureDetector(
          onVerticalDragUpdate: _onVerticalDragUpdate,
          onVerticalDragEnd: _onVerticalDragEnd,
          onTap: () => setState(() => _toggle = !_toggle),
          onLongPress: () {
            context.image(widget.media[_currentIndex], _pd);
          },
          child: Stack(
            children: [
              // Fullscreen media (background)
              _background,

              // Index indicator (optional)
              if (_media.length > 1)
                Positioned(
                  bottom: 24,
                  left: 0,
                  right: 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      _media.length,
                      (index) => Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: index == _currentIndex
                              ? Colors.white
                              : Colors.white38,
                        ),
                      ),
                    ),
                  ),
                ),

              //  Top floating app bar
              if (_toggle)
                SafeArea(
                  child: DirectionX(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _CircleButton(
                        Icons.close,
                        onTap: () => Navigator.pop(context),
                      ),
                      _CircleButton(
                        Icons.more_horiz,
                        onTap: () {
                          context.image(widget.media[_currentIndex], _pd);
                        },
                      ),
                    ],
                  ),
                ),

              //  Bottom actions
              if (_toggle) _bottom,
            ],
          ),
        ),
      ),
    );
  }

  Widget get _background => Transform.translate(
    offset: Offset(0, _dragOffset),
    child: PhotoViewGallery.builder(
      pageController: _pageController,
      scrollPhysics: const BouncingScrollPhysics(),
      backgroundDecoration: const BoxDecoration(color: Colors.transparent),
      itemCount: _media.length,
      builder: (_, index) => PhotoViewGalleryPageOptions(
        imageProvider: NetworkImage(_media[index]),
        minScale: PhotoViewComputedScale.contained,
        maxScale: PhotoViewComputedScale.covered * 2,
        heroAttributes: PhotoViewHeroAttributes(tag: _media[index]),
      ),
      onPageChanged: (i) => setState(() => _currentIndex = i),
    ),
  );

  Widget get _bottom => Positioned(
    left: 0,
    right: 0,
    bottom: 0,
    child: SafeArea(
      top: false,
      child: Obx(() {
        final data = pctrl.dataMapping[widget.id];
        if (data == null) return const SizedBox.shrink();

        return StreamBuilder(
          stream: actrl.actions$(data),
          builder: (_, snapshot) {
            if (!snapshot.hasData) return const SizedBox.shrink();

            return ClipRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.35),
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(12),
                    ),
                  ),
                  child: ActionsBar(
                    snapshot.data!,
                    start: 24,
                    end: 24,
                    top: 24,
                    bottom: 32,
                    color: Colors.white,
                  ),
                ),
              ),
            );
          },
        );
      }),
    ),
  );

  @override
  void dispose() {
    _pageController.dispose();
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
    super.dispose();
  }
}

class _CircleButton extends StatelessWidget {
  final IconData _icon;
  final VoidCallback? onTap;
  const _CircleButton(this._icon, {this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.4),
          shape: BoxShape.circle,
        ),
        child: Icon(_icon, color: Colors.white),
      ),
    );
  }
}
