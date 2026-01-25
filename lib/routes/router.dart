import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:semesta/public/extensions/extension.dart';
import 'package:semesta/routes/router_refresh_stream.dart';
import 'package:semesta/routes/routes.dart';
import 'package:semesta/public/helpers/generic_helper.dart';
import 'package:semesta/public/utils/transition_page.dart';
import 'package:semesta/src/components/layout/index.dart';
import 'package:semesta/src/pages/auth_page.dart';
import 'package:semesta/src/pages/avatar_preview_page.dart';
import 'package:semesta/src/pages/commnet_post_page.dart';
import 'package:semesta/src/pages/create_post_page.dart';
import 'package:semesta/src/pages/user_follow_page.dart';
import 'package:semesta/src/pages/image_preview_page.dart';
import 'package:semesta/src/pages/liked_page.dart';
import 'package:semesta/src/pages/post_details_page.dart';
import 'package:semesta/src/pages/profile_page.dart';
import 'package:semesta/src/pages/quote_post_page.dart';
import 'package:semesta/src/pages/saved_page.dart';
import 'package:semesta/src/pages/splash_page.dart';
import 'package:semesta/src/screens/explore_screen.dart';
import 'package:semesta/src/screens/home_screen.dart';
import 'package:semesta/src/screens/message_screen.dart';
import 'package:semesta/src/screens/notifications_screen.dart';
import 'package:semesta/src/screens/reels_screen.dart';

class AppRouter extends Routes {
  final rootNavKey = GlobalKey<NavigatorState>();
  static final appReady = ValueNotifier<bool>(false);

  GoRouter get router => GoRouter(
    debugLogDiagnostics: true,
    navigatorKey: rootNavKey,
    initialLocation: splash.path,
    refreshListenable: RouterRefreshStream(
      debounceStream(
        octrl.currentUser.stream,
        const Duration(milliseconds: 200),
      ),
      appReady,
    ),
    redirect: (context, state) {
      final goingTo = state.matchedLocation;
      final isLoggedIn = octrl.isLoggedIn;
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
      goRoute(splash, builder: (ctx, sts) => SplashPage()),
      goRoute(auth, builder: (ctx, sts) => const AuthPage()),

      // Shell (tabs)
      StatefulShellRoute.indexedStack(
        builder: (context, state, shell) => AppLayout(shell),
        branches: [
          branch(home, child: const HomeScreen()),
          branch(reel, child: const ReelsScreen()),
          branch(explore, child: const ExploreScreen()),
          branch(notify, child: const NotificationsScreen()),
          branch(messsage, child: const MessageScreen()),
        ],
      ),

      // ⚡ FULLSCREEN OUTSIDE TAB ROUTES ⚡
      goRoute(
        profile,
        pageBuilder: (context, state) {
          return TransitionPage(
            child: ProfilePage(
              state.pathOrQuery('id'),
              bool.parse(state.pathOrQuery('yourself', true)),
            ),
          );
        },
      ),
      goRoute(
        bookmark,
        pageBuilder: (context, state) {
          return TransitionPage(child: SavedPage(state.pathOrQuery('id')));
        },
      ),
      goRoute(
        favorite,
        pageBuilder: (context, state) {
          return TransitionPage(child: LikedPage(state.pathOrQuery('id')));
        },
      ),
      goRoute(
        avatar,
        pageBuilder: (context, state) {
          return TransitionPage(
            child: AvatarPreviewPage(state.pathOrQuery('id')),
            fullscreenDialog: true,
          );
        },
      ),
      goRoute(
        create,
        pageBuilder: (context, state) {
          return TransitionPage(
            child: CreatePostPage(),
            fullscreenDialog: true,
          );
        },
      ),
      goRoute(
        comment,
        pageBuilder: (context, state) {
          return TransitionPage(
            fullscreenDialog: true,
            child: CommnetPostPage(state.pathOrQuery('id')),
          );
        },
      ),
      goRoute(
        repost,
        pageBuilder: (context, state) {
          return TransitionPage(
            fullscreenDialog: true,
            child: QuotePostPage(state.pathOrQuery('id')),
          );
        },
      ),
      goRoute(
        media,
        pageBuilder: (context, state) {
          return TransitionPage(
            fullscreenDialog: true,
            child: ImagePreviewPage(
              state.pathOrQuery('id'),
              index: int.parse(state.pathOrQuery('index', true)),
            ),
          );
        },
      ),
      goRoute(
        friendship,
        pageBuilder: (context, state) {
          return TransitionPage(
            child: UserFollowPage(
              uid: state.pathOrQuery('id'),
              name: state.pathOrQuery('name', true),
              index: int.parse(state.pathOrQuery('index', true)),
            ),
          );
        },
      ),

      goRoute(
        detail,
        pageBuilder: (context, state) {
          return TransitionPage(
            child: PostDetailsPage(state.pathOrQuery('id')),
          );
        },
      ),
    ],
    extraCodec: const JsonCodec(),
    errorBuilder: (ctx, sts) {
      return Scaffold(
        body: Center(child: Text('No route for: ${sts.uri.toString()}')),
      );
    },
  );
}
