import 'package:flutter/material.dart';
import 'package:semesta/core/models/feed.dart';
import 'package:semesta/core/views/feed_view.dart';

class ReplyCard extends StatelessWidget {
  final FeedView vm;
  final Feed parent;
  const ReplyCard({super.key, required this.parent, required this.vm});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
