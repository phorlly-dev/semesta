import 'package:flutter/material.dart';
import 'package:semesta/core/models/post_model.dart';

class ReplyParams {
  final int id;
  final String label;
  final bool selected;
  final IconData icon;
  final VoidCallback? onTap;
  final PostVisibility option;

  ReplyParams({
    required this.option,
    required this.icon,
    required this.id,
    required this.label,
    required this.selected,
    this.onTap,
  });
}
