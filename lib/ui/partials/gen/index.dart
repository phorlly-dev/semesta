import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:semesta/app/routes/routes.dart';
import 'package:semesta/ui/partials/gen/_layout.dart';

class AppLayout extends StatefulWidget {
  final Widget child;
  final ScrollController scroller;
  const AppLayout({super.key, required this.child, required this.scroller});

  @override
  State<AppLayout> createState() => _AppLayoutState();
}

class _AppLayoutState extends State<AppLayout> {
  late ScrollController _scroller;

  @override
  void initState() {
    _scroller = widget.scroller;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final routes = Routes();
    final location = GoRouterState.of(context).matchedLocation;
    final index = routes.getIndexFromLocation(location);

    return Layout(
      content: widget.child,
      footer: BottomNavigationBar(
        currentIndex: index,
        onTap: (idx) {
          context.go(routes.paths[idx]);
          _scroller.jumpTo(0);
        },
        items: routes.items,
        type: BottomNavigationBarType.shifting,
      ),
    );
  }

  @override
  void dispose() {
    _scroller.dispose();
    super.dispose();
  }
}
