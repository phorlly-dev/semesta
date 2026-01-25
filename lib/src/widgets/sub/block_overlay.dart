import 'package:flutter/material.dart';
import 'package:semesta/src/widgets/sub/loading_animated.dart';

class BlockOverlay extends StatelessWidget {
  final String _title;
  const BlockOverlay(this._title, {super.key});

  @override
  Widget build(BuildContext context) {
    return AbsorbPointer(
      absorbing: true,
      child: Container(
        color: Colors.black.withValues(alpha: .8),
        alignment: Alignment.center,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            LoadingAnimated(color: Colors.white, cupertino: true),
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
      ),
    );
  }
}
