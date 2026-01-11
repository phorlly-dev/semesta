import 'package:flutter/material.dart';
import 'package:semesta/core/models/feed.dart';

class ReplyParams {
  final int id;
  final String label;
  final bool selected;
  final IconData icon;
  final VoidCallback? onTap;
  final Visible option;

  ReplyParams({
    required this.option,
    required this.icon,
    required this.id,
    required this.label,
    required this.selected,
    this.onTap,
  });
}

class CountState {
  final String key;
  final int value;
  const CountState(this.key, this.value);
}

class RouteNode {
  final String path;
  final String name;

  const RouteNode(this.path, this.name);

  RouteNode child(String subpath, String subname) {
    assert(
      !subpath.startsWith('/'),
      'Child route must be relative. Got:: $subpath',
    );

    return RouteNode('$path/$subpath', '$name.$subname');
  }
}
