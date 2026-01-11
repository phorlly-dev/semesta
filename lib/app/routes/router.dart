import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:semesta/app/routes/router_refresh_stream.dart';
import 'package:semesta/app/routes/routes.dart';
import 'package:semesta/core/views/generic_helper.dart';
import 'package:semesta/app/utils/transition_page.dart';
import 'package:semesta/ui/pages/create_post_page.dart';
import 'package:semesta/ui/pages/friendship_view_page.dart';
import 'package:semesta/ui/pages/image_preview_page.dart';
import 'package:semesta/ui/pages/profile_view_page.dart';
import 'package:semesta/ui/pages/reply_to_post_page.dart';
import 'package:semesta/ui/pages/repost_post_page.dart';
import 'package:semesta/ui/pages/avatar_preview_page.dart';
import 'package:semesta/ui/pages/bookmark_views_page.dart';
import 'package:semesta/ui/screens/message_screen.dart';
import 'package:semesta/ui/pages/auth_page.dart';
import 'package:semesta/ui/screens/explore_screen.dart';
import 'package:semesta/ui/screens/home_screen.dart';
import 'package:semesta/ui/components/layouts/index.dart';
import 'package:semesta/ui/screens/notifications_screen.dart';
import 'package:semesta/ui/pages/splash_page.dart';
import 'package:semesta/ui/screens/reels_screen.dart';

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
        builder: (context, state, shell) => AppLayout(child: shell),
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
          final uid = state.pathParameters['id'];
          final authed = state.uri.queryParameters['self'];
          if (uid == null) {
            throw StateError('Invalid user ID in post: $uid');
          }

          return TransitionPage(
            child: ProfileViewPage(
              uid: uid,
              authed: bool.parse(authed.toString()),
            ),
          );
        },
      ),
      goRoute(
        bookmark,
        pageBuilder: (context, state) {
          final uid = state.pathParameters['id'];
          if (uid == null) {
            throw StateError('Invalid user ID in post: $uid');
          }

          return TransitionPage(child: BookmarkViewsPage(uid: uid));
        },
      ),
      goRoute(
        avatar,
        pageBuilder: (context, state) {
          final uid = state.pathParameters['id'];
          if (uid == null) {
            throw StateError('Invalid user ID in post: $uid');
          }

          return TransitionPage(
            child: AvatarPreviewPage(uid: uid),
            fullscreenDialog: true,
          );
        },
      ),
      goRoute(
        create,
        pageBuilder: (context, state) =>
            TransitionPage(child: CreatePostPage(), fullscreenDialog: true),
      ),
      goRoute(
        comment,
        pageBuilder: (context, state) {
          final pid = state.pathParameters['id'];
          if (pid == null) {
            throw StateError('Invalid post ID: $pid');
          }

          return TransitionPage(
            child: ReplyToPostPage(pid: pid),
            fullscreenDialog: true,
          );
        },
      ),
      goRoute(
        repost,
        pageBuilder: (context, state) {
          final pid = state.pathParameters['id'];
          if (pid == null) {
            throw StateError('Invalid post ID: $pid');
          }

          return TransitionPage(
            child: PostRepost(pid: pid),
            fullscreenDialog: true,
          );
        },
      ),
      goRoute(
        media,
        pageBuilder: (context, state) {
          final pid = state.pathParameters['id'];
          final idx = int.parse(state.uri.queryParameters['index'] ?? '0');

          return TransitionPage(
            child: ImagePreviewPage(pid: pid.toString(), index: idx),
            fullscreenDialog: true,
          );
        },
      ),
      goRoute(
        friendship,
        pageBuilder: (context, state) {
          final uid = state.pathParameters['id']!;
          final displayName = state.uri.queryParameters['name'];
          final idx = int.parse(state.uri.queryParameters['index'] ?? '0');

          return TransitionPage(
            child: FriendshipViewPage(
              uid: uid,
              index: idx,
              displayName: displayName.toString(),
            ),
          );
        },
      ),

      // goRoute(
      //   postDatails,
      //   pageBuilder: (context, state) {
      //     final args = state.extra as Map<String, dynamic>;
      //     final user = args['user'] as UserModel;
      //     final post = args['post'] as PostModel;
      //     return TransitionPage(
      //       child: PostDetailsPage(user: user, post: post),
      //     );
      //   },
      // ),
    ],
    extraCodec: const JsonCodec(),
    errorBuilder: (ctx, st) {
      return Scaffold(
        body: Center(child: Text('No route for: ${st.uri.toString()}')),
      );
    },
  );
}
