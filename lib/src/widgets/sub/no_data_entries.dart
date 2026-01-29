import 'package:flutter/material.dart';
import 'package:semesta/public/extensions/extension.dart';

class NoDataEntries extends StatelessWidget {
  final String _message;
  const NoDataEntries(this._message, {super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        _message,
        style: context.text.bodyLarge?.copyWith(fontWeight: FontWeight.w400),
      ),
    );
  }
}
