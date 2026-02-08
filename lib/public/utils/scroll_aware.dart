import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:semesta/public/utils/type_def.dart';

class ScrollAware extends StatefulWidget {
  final Defo<bool, Widget> _builder;
  const ScrollAware(this._builder, {super.key});

  @override
  State<ScrollAware> createState() => _ScrollAwareState();
}

class _ScrollAwareState extends State<ScrollAware> {
  bool _visible = true;

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: (notify) {
        if (notify is UserScrollNotification) {
          final dir = notify.direction;
          if (dir == ScrollDirection.reverse && _visible) {
            setState(() => _visible = false);
          } else if (dir == ScrollDirection.forward && !_visible) {
            setState(() => _visible = true);
          }
        }

        // Fallback: no scroll extent → show app bar
        if (notify.metrics.maxScrollExtent == 0) {
          setState(() => _visible = true);
        }

        return _visible;
      },
      child: widget._builder(_visible),
    );
  }
}
