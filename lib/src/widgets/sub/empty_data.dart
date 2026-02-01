import 'package:flutter/material.dart';
import 'package:semesta/public/extensions/extension.dart';

class EmptyData extends StatelessWidget {
  final String _message;
  const EmptyData(this._message, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Text(
        _message,
        textAlign: TextAlign.center,
        style: context.text.bodyLarge?.copyWith(fontWeight: FontWeight.w400),
      ),
    );
  }
}
