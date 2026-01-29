import 'package:flutter/material.dart';
import 'package:semesta/public/extensions/extension.dart';
import 'package:semesta/src/widgets/sub/direction_y.dart';

class CustomBottomSheet<T> {
  final BuildContext _context;
  final List<Widget> children;
  final MainAxisSize mainAxisSize;
  CustomBottomSheet(
    this._context, {
    required this.children,
    this.mainAxisSize = MainAxisSize.min,
  }) {
    showModalBottomSheet<T>(
      context: _context,
      backgroundColor: _context.theme.cardColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        child: DirectionY(
          mainAxisSize: mainAxisSize,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),

            ...children,
          ],
        ),
      ),
    );
  }
}
