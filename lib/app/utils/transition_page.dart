import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class TransitionPage extends CustomTransitionPage {
  TransitionPage({required super.child, super.key})
    : super(
        transitionDuration: const Duration(milliseconds: 400),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          final offsetTween = Tween(
            begin: const Offset(0.0, 0.1),
            end: Offset.zero,
          ).chain(CurveTween(curve: Curves.easeOut));
          return SlideTransition(
            position: animation.drive(offsetTween),
            child: FadeTransition(opacity: animation, child: child),
          );
        },
      );
}
