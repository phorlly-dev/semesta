import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

enum TransitionStyle {
  rightToLeft,
  leftToRight,
  bottomToTop,
  topToBottom,
  fade,
}

class TransitionPage extends CustomTransitionPage {
  final TransitionStyle style;
  TransitionPage({
    required super.child,
    super.fullscreenDialog,
    super.key,
    this.style = TransitionStyle.rightToLeft,
  }) : super(
         transitionDuration: Durations.long4,
         transitionsBuilder: (_, animation, axs, child) {
           final curved = CurvedAnimation(
             parent: animation,
             curve: Curves.easeOutExpo,
             reverseCurve: Curves.easeOutCubic,
           );

           if (style == TransitionStyle.fade) {
             return FadeTransition(opacity: curved, child: child);
           }

           final beginOffset = switch (style) {
             TransitionStyle.fade => Offset.zero,
             TransitionStyle.rightToLeft => const Offset(1, 0),
             TransitionStyle.leftToRight => const Offset(-1, 0),
             TransitionStyle.bottomToTop => const Offset(0, 1),
             TransitionStyle.topToBottom => const Offset(0, -1),
           };

           return SlideTransition(
             position: Tween<Offset>(
               begin: beginOffset,
               end: Offset.zero,
             ).animate(curved),
             child: FadeTransition(opacity: curved, child: child),
           );
         },
       );
}
