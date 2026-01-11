import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:semesta/app/utils/params.dart';

mixin RouterMixin {
  GoRoute goRoute(
    RouteNode route, {
    List<RouteBase>? routes,
    List<RouteBase>? subRoutes,
    GoRouterRedirect? redirect,
    GoRouterWidgetBuilder? builder,
    GoRouterPageBuilder? pageBuilder,
  }) => GoRoute(
    path: route.path,
    name: route.name,
    builder: builder,
    pageBuilder: pageBuilder,
    routes: subRoutes ?? routes ?? const [],
    redirect: redirect,
  );

  StatefulShellBranch branch(
    RouteNode route, {
    required Widget child,
    List<RouteBase>? routes,
    ValueChanged<GoRouterState>? initPage,
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
    _item(Icons.search, 'Explore'),
    _item(Icons.ondemand_video_rounded, 'Reels'),
    _item(Icons.home, 'Home'),
    _item(Icons.notifications_none, 'Notifications'),
    _item(Icons.email_outlined, 'Messages'),
  ];

  //helper
  BottomNavigationBarItem _item(IconData icon, String label) {
    return BottomNavigationBarItem(icon: Icon(icon), label: label);
  }
}

mixin UserRoutes {
  RouteNode get avatar => _users.child('avatar', 'avatar');
  RouteNode get profile => _users.child('profile', 'profile');
  RouteNode get bookmark => _users.child('bookmark', 'bookmark');
  RouteNode get _users => const RouteNode('/users/:id', 'users');
  RouteNode get friendship => _users.child('friendship', 'friendship');
}

mixin PostRoutes {
  RouteNode get media => _posts.child('media', 'media');
  RouteNode get repost => _posts.child('repost', 'repost');
  RouteNode get detail => _posts.child('detail', 'detail');
  RouteNode get comment => _posts.child('comment', 'comment');
  RouteNode get _posts => const RouteNode('/posts/:id', 'posts');
  RouteNode get create => const RouteNode('/posts/create', 'posts.create');
}
