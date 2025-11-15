import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:semesta/app/bindings/home_binding.dart';
import 'package:semesta/app/routes/router_refresh_stream.dart';
import 'package:semesta/app/routes/routes.dart';
import 'package:semesta/app/utils/transition_page.dart';
import 'package:semesta/core/controllers/auth_controller.dart';
import 'package:semesta/core/models/story_model.dart';
import 'package:semesta/core/models/user_model.dart';
import 'package:semesta/ui/pages/ousides/story_detail.dart';
import 'package:semesta/ui/pages/ousides/auth.dart';
import 'package:semesta/ui/pages/insides/friends.dart';
import 'package:semesta/ui/pages/insides/home.dart';
import 'package:semesta/ui/partials/gen/index.dart';
import 'package:semesta/ui/pages/insides/marketplace.dart';
import 'package:semesta/ui/pages/insides/notifications.dart';
import 'package:semesta/ui/pages/ousides/splash.dart';
import 'package:semesta/ui/pages/insides/watches.dart';

class AppRouter extends Routes {
  final _auth = Get.find<AuthController>();
  String get uid => _auth.currentUser.value?.uid ?? '';
  static final appReady = ValueNotifier<bool>(false);
  final rootNavKey = GlobalKey<NavigatorState>();
  final controller = ScrollController();

  GoRouter get router => GoRouter(
    debugLogDiagnostics: true,
    navigatorKey: rootNavKey,
    initialLocation: splash.path,
    refreshListenable: RouterRefreshStream(
      debounceStream(
        _auth.currentUser.stream,
        const Duration(milliseconds: 200),
      ),
      appReady,
    ),
    redirect: (context, state) {
      final goingTo = state.matchedLocation;
      final isLoggedIn = _auth.isLoggedIn;
      final isReady = appReady.value;

      // 1️⃣ Always go to Splash until appReady is true
      if (!isReady && goingTo != splash.path) {
        return splash.path;
      }

      // 2️⃣ Once ready, control navigation by login state
      if (isReady) {
        // ✅ Logged in → go home unless already there
        if (isLoggedIn && (goingTo == splash.path || goingTo == auth.path)) {
          return home.path;
        }

        // 🚪 Logged out → force auth unless already there
        if (!isLoggedIn && (goingTo == splash.path || goingTo == home.path)) {
          return auth.path;
        }
      }

      // 3️⃣ Default: stay where you are
      return null;
    },
    routes: [
      goRoute(splash, builder: (ctx, sts) => Splash()),
      goRoute(auth, builder: (ctx, sts) => Auth(controller: _auth)),

      // Shell (tabs)
      StatefulShellRoute.indexedStack(
        builder: (context, state, shell) =>
            AppLayout(scroller: controller, child: shell),
        branches: [
          branch(
            home,
            child: Home(scroller: controller, userId: uid),
            initPage: (state) => HomeBinding().dependencies(),
          ),
          branch(watches, child: const Watches()),
          branch(friends, child: const Friends()),
          branch(notifications, child: const Notifications()),
          branch(marketplace, child: const Marketplace()),
        ],
      ),

      // ⚡ FULLSCREEN OUTSIDE TAB ROUTES ⚡
      goRoute(
        storyDetail,
        pageBuilder: (context, state) {
          final extra = state.extra as Map<String, dynamic>;
          final story = StoryModel.fromMap(extra['story']);
          final user = UserModel.fromMap(extra['user']);

          return TransitionPage(
            child: StoryDetail(story: story, user: user),
          );
        },
      ),
    ],
    extraCodec: const JsonCodec(),
    errorBuilder: (ctx, st) {
      return Scaffold(
        body: Center(child: Text('No route for: ${st.uri.toString()}')),
      );
    },
  );
}
