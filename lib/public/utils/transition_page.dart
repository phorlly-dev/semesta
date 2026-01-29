import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class TransitionPage extends CustomTransitionPage {
  TransitionPage({required super.child, super.fullscreenDialog, super.key})
    : super(
        transitionDuration: const Duration(milliseconds: 600),
        transitionsBuilder: (_, animation, sa, child) => SlideTransition(
          position: animation.drive(
            Tween(
              end: Offset.zero,
              begin: const Offset(0.0, 0.1),
            ).chain(CurveTween(curve: Curves.easeOut)),
          ),
          child: FadeTransition(opacity: animation, child: child),
        ),
      );
}
