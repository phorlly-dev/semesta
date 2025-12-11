import 'package:flutter/material.dart';

class NoDataEntries extends StatelessWidget {
  final String message;
  const NoDataEntries({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Center(
      child: Text(
        message,
        style: text.bodyLarge?.copyWith(fontWeight: FontWeight.w400),
      ),
    );
  }
}
