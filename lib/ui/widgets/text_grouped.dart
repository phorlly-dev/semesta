import 'package:flutter/material.dart';

class TextGrouped extends StatelessWidget {
  final String first, second;
  final Color? secondColor;

  const TextGrouped({
    super.key,
    required this.first,
    required this.second,
    this.secondColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final text = theme.textTheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: 2),
      child: Row(
        spacing: 6,
        children: [
          Text(
            first,
            style: secondColor == null
                ? text.bodyMedium?.copyWith(fontWeight: FontWeight.w600)
                : text.bodyLarge,
          ),
          Text(
            second,
            style: text.bodyMedium?.copyWith(
              color: secondColor ?? theme.colorScheme.primary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
