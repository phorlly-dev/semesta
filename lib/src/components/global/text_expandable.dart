import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TextExpandable extends StatefulWidget {
  final String _text;
  final Color? textColor;
  final int trimLength; // Customize cutoff
  final ValueChanged<String>? onLink;
  const TextExpandable(
    this._text, {
    super.key,
    this.textColor,
    this.trimLength = 135,
    this.onLink,
  });

  @override
  State<TextExpandable> createState() => _TextExpandableState();
}

class _TextExpandableState extends State<TextExpandable> {
  bool _expanded = false;
  late String _visibleText;
  late bool _hasOverflow;

  @override
  void initState() {
    super.initState();
    _prepareText();
  }

  void _prepareText() {
    final text = widget._text.trim();

    // Cut text safely (avoid splitting emojis)
    if (text.characters.length > widget.trimLength) {
      _visibleText = text.characters.take(widget.trimLength).toString();

      // stop at newline if early
      final newlineIndex = _visibleText.indexOf('\n');
      if (newlineIndex != -1) {
        _visibleText = _visibleText.substring(0, newlineIndex);
      }
      _hasOverflow = true;
    } else {
      _visibleText = text;
      _hasOverflow = false;
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
            ..onTap = () => widget.onLink?.call(word),
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
    final displayText = _expanded ? widget._text : _visibleText;

    return GestureDetector(
      child: RichText(
        text: TextSpan(
          style: TextStyle(color: color, fontSize: 16, height: 1.4),
          children: [
            ..._buildSpans(displayText),
            if (_hasOverflow)
              TextSpan(
                text: !_expanded ? '... Read more' : '',
                style: const TextStyle(
                  color: Colors.blueGrey,
                  fontWeight: FontWeight.w400,
                ),
                recognizer: TapGestureRecognizer()
                  ..onTap = () => setState(() => _expanded = !_expanded),
              ),
          ],
        ),
      ),
      onTap: () => setState(() => _expanded = !_expanded),
    );
  }
}
