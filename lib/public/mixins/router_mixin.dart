import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:semesta/public/helpers/params_helper.dart';

mixin RouterMixin {
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
  RouteNode get bookmark => _users.child('saved', 'saved');
  RouteNode get favorite => _users.child('liked', 'liked');
  RouteNode get edit => _users.child('edit', 'edit');
  RouteNode get _users => const RouteNode('/users/:id', 'users');
  RouteNode get friendship => _users.child('follow', 'follow');
}

mixin PostRoutes {
  RouteNode get media => _posts.child('media', 'media');
  RouteNode get repost => _posts.child('repost', 'repost');
  RouteNode get detail => _posts.child('detail', 'detail');
  RouteNode get comment => _posts.child('reply', 'reply');
  RouteNode get change => _posts.child('edit', 'edit');
  RouteNode get _posts => const RouteNode('/posts/:id', 'posts');
  RouteNode get create => const RouteNode('/posts/create', 'posts.create');
}
