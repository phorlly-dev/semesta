import 'package:flutter/material.dart';

class HighlightController extends TextEditingController {
  HighlightController({super.text});

  final RegExp _pattern = RegExp(r'(?<=^|\s)([#@][A-Za-z0-9_]+)');

  @override
  TextSpan buildTextSpan({
    required BuildContext context,
    TextStyle? style,
    required bool withComposing,
  }) {
    final spans = <TextSpan>[];
    int start = 0;

    for (final match in _pattern.allMatches(text)) {
      if (match.start > start) {
        spans.add(
          TextSpan(text: text.substring(start, match.start), style: style),
        );
      }

      final token = match.group(0)!;
      final isHashtag = token.startsWith('#');

      spans.add(
        TextSpan(
          text: token,
          style: style?.copyWith(
            color: Colors.blue,
            fontWeight: FontWeight.w600,
            decoration: isHashtag ? TextDecoration.underline : null,
          ),
        ),
      );

      start = match.end;
    }

    if (start < text.length) {
      spans.add(TextSpan(text: text.substring(start), style: style));
    }

    return TextSpan(children: spans, style: style);
  }
}
