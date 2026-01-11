import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:semesta/app/utils/type_def.dart';

class ScrollAwareAppBar extends StatefulWidget {
  final PropsCallback<bool, Widget> builder;
  const ScrollAwareAppBar({super.key, required this.builder});

  @override
  State<ScrollAwareAppBar> createState() => _ScrollAwareAppBarState();
}

class _ScrollAwareAppBarState extends State<ScrollAwareAppBar> {
  bool _visible = true;

  @override
  Widget build(BuildContext context) {
    return NotificationListener<UserScrollNotification>(
      onNotification: (n) {
        if (n.direction == ScrollDirection.reverse && _visible) {
          setState(() => _visible = false);
        } else if (n.direction == ScrollDirection.forward && !_visible) {
          setState(() => _visible = true);
        }

        return false;
      },
      child: widget.builder(_visible),
    );
  }
}
