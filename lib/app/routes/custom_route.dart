import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:semesta/app/routes/route_params.dart';

class CustomRoute {
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
}
