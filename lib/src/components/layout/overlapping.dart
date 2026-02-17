import 'package:flutter/material.dart';
import 'package:semesta/src/widgets/sub/block_overlay.dart';

class Overlapping extends StatelessWidget {
  final bool loading;
  final Widget child;
  final String message;
  const Overlapping({
    super.key,
    this.loading = false,
    this.message = 'Saving',
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(children: [child, if (loading) BlockOverlay(message)]);
  }
}
