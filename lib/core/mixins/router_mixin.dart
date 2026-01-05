import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:semesta/app/utils/params.dart';

mixin RouterMixin {
  GoRoute goRoute(
    RouteParams route, {
    GoRouterWidgetBuilder? builder,
    GoRouterPageBuilder? pageBuilder,
    List<RouteBase>? subRoutes,
    List<RouteBase>? routes, // alias for nested
    GoRouterRedirect? redirect,
  }) => GoRoute(
    path: route.path,
    name: route.name,
    builder: builder,
    pageBuilder: pageBuilder,
    routes: subRoutes ?? routes ?? const [],
    redirect: redirect,
  );

  StatefulShellBranch branch(
    RouteParams route, {
    required Widget child,
    List<RouteBase>? routes,
    void Function(GoRouterState state)? initPage,
  }) => StatefulShellBranch(
    routes: [
      ...?routes,
      goRoute(
        route,
        pageBuilder: (context, state) {
          if (initPage != null) initPage(state);
          return NoTransitionPage(child: child);
        },
      ),
    ],
  );

  //nav menu
  List<BottomNavigationBarItem> get items => [
    item(Icons.search, 'Explore'),
    item(Icons.ondemand_video_rounded, 'Reels'),
    item(Icons.home, 'Home'),
    item(Icons.notifications_none, 'Notifications'),
    item(Icons.email_outlined, 'Messages'),
  ];

  //helper
  String convert(String params) => '/$params-page';
  BottomNavigationBarItem item(IconData icon, [String? label]) {
    return BottomNavigationBarItem(icon: Icon(icon), label: label);
  }
}
