import 'package:flutter/material.dart';

class CustomBottomSheet<T> {
  final BuildContext context;
  final List<Widget> children;
  final MainAxisSize mainAxisSize;

  CustomBottomSheet(
    this.context, {
    required this.children,
    this.mainAxisSize = MainAxisSize.min,
  }) {
    final theme = Theme.of(context);
    showModalBottomSheet<T>(
      context: context,
      backgroundColor: theme.cardColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: mainAxisSize,
              crossAxisAlignment: CrossAxisAlignment.start,
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
      },
    );
  }
}
