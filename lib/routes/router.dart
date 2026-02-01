import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:semesta/public/extensions/extension.dart';
import 'package:semesta/routes/router_refresh.dart';
import 'package:semesta/routes/routes.dart';
import 'package:semesta/public/helpers/generic_helper.dart';
import 'package:semesta/public/utils/transition_page.dart';
import 'package:semesta/src/components/layout/_index.dart';
import 'package:semesta/src/pages/auth.dart';
import 'package:semesta/src/pages/avatar_preview.dart';
import 'package:semesta/src/pages/commnet_post.dart';
import 'package:semesta/src/pages/create_post.dart';
import 'package:semesta/src/pages/edit_post.dart';
import 'package:semesta/src/pages/edit_profile.dart';
import 'package:semesta/src/pages/user_follow.dart';
import 'package:semesta/src/pages/image_preview.dart';
import 'package:semesta/src/pages/liked_posts.dart';
import 'package:semesta/src/pages/post_details.dart';
import 'package:semesta/src/pages/profile_page.dart';
import 'package:semesta/src/pages/quote_post.dart';
import 'package:semesta/src/pages/saved_posts.dart';
import 'package:semesta/src/pages/splash_page.dart';
import 'package:semesta/src/screens/explore.dart';
import 'package:semesta/src/screens/home.dart';
import 'package:semesta/src/screens/message.dart';
import 'package:semesta/src/screens/notifications.dart';
import 'package:semesta/src/screens/reels.dart';

class AppRouter extends Routes {
  final rootNavKey = GlobalKey<NavigatorState>();
  static final appReady = ValueNotifier<bool>(false);

  GoRouter get router => GoRouter(
    debugLogDiagnostics: true,
    navigatorKey: rootNavKey,
    initialLocation: splash.path,
    refreshListenable: RouterRefresh(
      debounce(octrl.currentUser.stream, const Duration(milliseconds: 200)),
      appReady,
    ),
    redirect: (_, state) {
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
      goRoute(splash, builder: (_, sts) => SplashPage()),
      goRoute(auth, builder: (_, sts) => const AuthPage()),

      // Shell (tabs)
      StatefulShellRoute.indexedStack(
        builder: (_, state, shell) => AppLayout(shell),
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
        pageBuilder: (_, state) {
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
        pageBuilder: (_, state) {
          return TransitionPage(child: SavedPostsPage(state.pathOrQuery('id')));
        },
      ),
      goRoute(
        favorite,
        pageBuilder: (_, state) {
          return TransitionPage(child: LikedPostsPage(state.pathOrQuery('id')));
        },
      ),
      goRoute(
        avatar,
        pageBuilder: (_, state) {
          return TransitionPage(
            child: AvatarPreviewPage(state.pathOrQuery('id')),
            fullscreenDialog: true,
          );
        },
      ),
      goRoute(
        create,
        pageBuilder: (_, state) {
          return TransitionPage(
            child: CreatePostPage(),
            fullscreenDialog: true,
          );
        },
      ),
      goRoute(
        comment,
        pageBuilder: (_, state) {
          return TransitionPage(
            fullscreenDialog: true,
            child: CommnetPostPage(state.pathOrQuery('id')),
          );
        },
      ),
      goRoute(
        repost,
        pageBuilder: (_, state) {
          return TransitionPage(
            fullscreenDialog: true,
            child: QuotePostPage(state.pathOrQuery('id')),
          );
        },
      ),
      goRoute(
        media,
        pageBuilder: (_, state) {
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
        pageBuilder: (_, state) {
          return TransitionPage(
            child: UserFollowPage(
              state.pathOrQuery('id'),
              state.pathOrQuery('name', true),
              index: int.parse(state.pathOrQuery('index', true)),
            ),
          );
        },
      ),

      goRoute(
        detail,
        pageBuilder: (_, state) {
          return TransitionPage(
            child: PostDetailsPage(state.pathOrQuery('id')),
          );
        },
      ),
      goRoute(
        change,
        pageBuilder: (_, state) {
          return TransitionPage(child: EditPostPage(state.pathOrQuery('id')));
        },
      ),
      goRoute(
        edit,
        pageBuilder: (_, state) {
          return TransitionPage(
            child: EditProfilePage(state.pathOrQuery('id')),
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
