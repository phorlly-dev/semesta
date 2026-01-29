import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ExpandableText extends StatefulWidget {
  final String _text;
  final Color? textColor;
  final int trimLength; // Customize cutoff
  final ValueChanged<String>? onTag;
  const ExpandableText(
    this._text, {
    super.key,
    this.textColor,
    this.trimLength = 135,
    this.onTag,
  });

  @override
  State<ExpandableText> createState() => _ExpandableTextState();
}

class _ExpandableTextState extends State<ExpandableText> {
  bool expanded = false;
  late String visibleText;
  late bool hasOverflow;

  @override
  void initState() {
    super.initState();
    _prepareText();
  }

  void _prepareText() {
    final text = widget._text.trim();

    // Cut text safely (avoid splitting emojis)
    if (text.characters.length > widget.trimLength) {
      visibleText = text.characters.take(widget.trimLength).toString();
      // stop at newline if early
      final newlineIndex = visibleText.indexOf('\n');
      if (newlineIndex != -1) {
        visibleText = visibleText.substring(0, newlineIndex);
      }
      hasOverflow = true;
    } else {
      visibleText = text;
      hasOverflow = false;
    }
  }

  List<TextSpan> _buildSpans(String text) {
    final spans = <TextSpan>[];
    final regex = RegExp(r'(@\w+|#\w+)');
    int start = 0;

    for (final match in regex.allMatches(text)) {
      if (match.start > start) {
        spans.add(TextSpan(text: text.substring(start, match.start)));
      }
      final word = match.group(0)!;
      spans.add(
        TextSpan(
          text: word,
          style: const TextStyle(color: Colors.blueAccent),
          recognizer: TapGestureRecognizer()
            ..onTap = () => widget.onTag?.call(word),
        ),
      );
      start = match.end;
    }

    if (start < text.length) {
      spans.add(TextSpan(text: text.substring(start)));
    }

    return spans;
  }

  @override
  Widget build(BuildContext context) {
    Color textColor() {
      if (context.isDarkMode) {
        return Colors.white;
      } else {
        return Colors.black87;
      }
    }

    final color = widget.textColor ?? textColor();
    final displayText = expanded ? widget._text : visibleText;

    return GestureDetector(
      onTap: () => setState(() => expanded = !expanded),
      child: RichText(
        textAlign: TextAlign.start,
        text: TextSpan(
          style: TextStyle(color: color, fontSize: 16, height: 1.4),
          children: [
            ..._buildSpans(displayText),
            if (hasOverflow)
              TextSpan(
                text: !expanded ? '... Read more' : '',
                style: const TextStyle(
                  color: Colors.blueGrey,
                  fontWeight: FontWeight.w400,
                ),
                recognizer: TapGestureRecognizer()
                  ..onTap = () => setState(() => expanded = !expanded),
              ),
          ],
        ),
      ),
    );
  }
}
