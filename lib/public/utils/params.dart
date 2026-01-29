import 'package:flutter/material.dart';
import 'package:semesta/app/models/feed.dart';
import 'package:semesta/public/helpers/utils_helper.dart';

class VisibleToPost {
  final int id;
  final String label;
  final bool selected;
  final IconData icon;
  final VoidCallback? onTap;
  final Visible option;
  const VisibleToPost({
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
  final FeedKind kind;
  const CountState(this.key, this.value, {this.kind = FeedKind.posted});
}

class RouteNode {
  final String path;
  final String name;
  const RouteNode(this.path, this.name);

  RouteNode child(String subpath, String subname) {
    assert(!subpath.startsWith('/'), 'Child route must be relative: $subpath');

    return RouteNode('$path/$subpath', '$name.$subname');
  }
}
