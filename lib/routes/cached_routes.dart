import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:semesta/public/helpers/params_helper.dart';
import 'package:semesta/public/utils/type_def.dart';

abstract mixin class ICachedRoutes {
  final _cache = <String, RouteNode>{};
  RouteNode cached(RouteNode Function() builder) {
    final node = builder();
    return _cache.putIfAbsent(node.name, () => node);
  }

  GoRoute route(
    RouteNode provider, {
    GoRouterRedirect? redirect,
    GoRouterWidgetBuilder? builder,
    GoRouterPageBuilder? pageBuilder,
    List<RouteBase> routes = const <RouteBase>[],
  }) => GoRoute(
    path: provider.path,
    name: provider.name,
    routes: routes,
    builder: builder,
    redirect: redirect,
    pageBuilder: pageBuilder,
  );

  StatefulShellBranch branch(
    RouteNode provider,
    Widget child, {
    List<RouteBase>? routes,
    ValueChanged<GoRouterState>? initPage,
  }) => StatefulShellBranch(
    routes: [
      ...?routes,
      route(
        provider,
        pageBuilder: (_, state) {
          initPage?.call(state);
          return NoTransitionPage(child: child);
        },
      ),
    ],
  );

  //path menu
  AsList get paths;
  AsList get titles;

  int getIndex(String location) {
    return paths.indexWhere((p) => location.startsWith(p));
  }

  //nav menu
  List<BottomNavigationBarItem> get items;

  //helper
  BottomNavigationBarItem item(IconData icon, String label) {
    return BottomNavigationBarItem(icon: Icon(icon), label: label);
  }
}

abstract mixin class IScreenRoutes {
  // root (absolute)
  RouteNode get home;
  RouteNode get explore;
  RouteNode get reel;
  RouteNode get notify;
  RouteNode get messsage;

  //Outside
  RouteNode get splash;
  RouteNode get auth;
}

abstract mixin class IUserRoutes {
  RouteNode get avatar;
  RouteNode get profile;
  RouteNode get bookmark;
  RouteNode get favorite;
  RouteNode get edit;
  RouteNode get user;
  RouteNode get friendship;
}

abstract mixin class IPostRoutes {
  RouteNode get media;
  RouteNode get repost;
  RouteNode get detail;
  RouteNode get comment;
  RouteNode get change;
  RouteNode get posts;
  RouteNode get create;
}
