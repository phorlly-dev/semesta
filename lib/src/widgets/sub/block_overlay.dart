import 'package:flutter/material.dart';
import 'package:semesta/src/widgets/sub/direction_y.dart';
import 'package:semesta/src/widgets/sub/animated_loader.dart';

class BlockOverlay extends StatelessWidget {
  final String _title;
  const BlockOverlay(this._title, {super.key});

  @override
  Widget build(BuildContext context) {
    return AbsorbPointer(
      absorbing: true,
      child: DirectionY(
        alignment: Alignment.center,
        mainAxisSize: MainAxisSize.min,
        color: Colors.black.withValues(alpha: .8),
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          AnimatedLoader(color: Colors.white, cupertino: true),
          SizedBox(height: 16),
          Text(
            '$_title...',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              decoration: TextDecoration.none, // ❌ remove underline
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
