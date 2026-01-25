import 'package:flutter/material.dart';

class NoDataEntries extends StatelessWidget {
  final String _message;
  const NoDataEntries(this._message, {super.key});

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Center(
      child: Text(
        _message,
        style: text.bodyLarge?.copyWith(fontWeight: FontWeight.w400),
      ),
    );
  }
}
