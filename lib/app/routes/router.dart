import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:semesta/app/routes/router_refresh_stream.dart';
import 'package:semesta/app/routes/routes.dart';
import 'package:semesta/core/controllers/auth_controller.dart';
import 'package:semesta/ui/pages/auth.dart';
import 'package:semesta/ui/pages/home.dart';
import 'package:semesta/ui/pages/splash.dart';

class AppRouter extends Routes {
  final _auth = Get.find<AuthController>();
  static final appReady = ValueNotifier<bool>(false);
  final rootNavKey = GlobalKey<NavigatorState>();

  GoRouter get router => GoRouter(
    navigatorKey: rootNavKey,
    initialLocation: splash.path,
    refreshListenable: RouterRefreshStream(_auth.item.stream, appReady),
    redirect: (context, state) {
      final goingTo = state.matchedLocation;
      final isLoggedIn = _auth.isLoggedIn;
      final isReady = appReady.value;

      // Step 1: Always show splash first until ready
      if (!isReady && goingTo != splash.path) {
        return splash.path;
      }

      // Step 2: Once ready, route by login state
      if (isReady) {
        if (isLoggedIn && (goingTo == splash.path || goingTo == auth.path)) {
          return home.path;
        }

        if (!isLoggedIn && (goingTo == splash.path || goingTo == home.path)) {
          return auth.path;
        }
      }

      return null;
    },
    routes: [
      goRoute(splash, builder: (ctx, sts) => Splash()),
      goRoute(home, builder: (ctx, sts) => Home()),
      goRoute(auth, builder: (ctx, sts) => Auth(controller: _auth)),
    ],
  );
}
