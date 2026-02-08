import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:semesta/public/extensions/route_extension.dart';
import 'package:semesta/routes/router_refresh.dart';
import 'package:semesta/routes/routes.dart';
import 'package:semesta/public/helpers/generic_helper.dart';
import 'package:semesta/public/utils/transition_page.dart';
import 'package:semesta/src/components/layout/_index.dart';
import 'package:semesta/src/components/layout/_page.dart';
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
      debounce(octrl.currentUser.stream, Durations.short4),
      appReady,
    ),
    redirect: (_, state) {
      final goingTo = state.matchedLocation;
      final loggedIn = octrl.loggedIn;
      final ready = appReady.value;

      // 1️⃣ Always go to Splash until appReady is true
      if (!ready && goingTo != splash.path) {
        return splash.path;
      }

      // 2️⃣ Once ready, control navigation by login state
      if (ready) {
        // ✅ Logged in → go home unless already there
        if (loggedIn && (goingTo == splash.path || goingTo == auth.path)) {
          return home.path;
        }

        // 🚪 Logged out → force auth unless already there
        if (!loggedIn && (goingTo == splash.path || goingTo == home.path)) {
          return auth.path;
        }
      }

      // 3️⃣ Default: stay where you are
      return null;
    },
    routes: [
      route(splash, builder: (_, state) => SplashPage()),
      route(auth, builder: (_, state) => const AuthPage()),

      // Shell (tabs)
      StatefulShellRoute.indexedStack(
        builder: (_, state, shell) => AppLayout(shell),
        branches: [
          branch(home, const HomeScreen()),
          branch(reel, const ReelsScreen()),
          branch(explore, const ExploreScreen()),
          branch(notify, const NotificationsScreen()),
          branch(messsage, const MessageScreen()),
        ],
      ),

      // ⚡ FULLSCREEN OUTSIDE TAB ROUTES ⚡
      route(
        profile,
        pageBuilder: (_, state) => TransitionPage(
          child: ProfilePage(
            state.pathOrQuery('id'),
            bool.parse(state.pathOrQuery('yourself', true)),
          ),
        ),
      ),
      route(
        bookmark,
        pageBuilder: (_, state) {
          return TransitionPage(child: SavedPostsPage(state.pathOrQuery('id')));
        },
      ),
      route(
        favorite,
        pageBuilder: (_, state) {
          return TransitionPage(child: LikedPostsPage(state.pathOrQuery('id')));
        },
      ),
      route(
        avatar,
        pageBuilder: (_, state) => TransitionPage(
          fullscreenDialog: true,
          style: TransitionStyle.fade,
          child: AvatarPreviewPage(state.pathOrQuery('id')),
        ),
      ),
      route(
        create,
        pageBuilder: (_, state) => TransitionPage(
          fullscreenDialog: true,
          style: TransitionStyle.bottomToTop,
          child: CreatePostPage(),
        ),
      ),
      route(
        comment,
        pageBuilder: (_, state) => TransitionPage(
          fullscreenDialog: true,
          style: TransitionStyle.bottomToTop,
          child: CommnetPostPage(state.pathOrQuery('id')),
        ),
      ),
      route(
        repost,
        pageBuilder: (_, state) => TransitionPage(
          fullscreenDialog: true,
          style: TransitionStyle.bottomToTop,
          child: QuotePostPage(state.pathOrQuery('id')),
        ),
      ),
      route(
        media,
        pageBuilder: (_, state) => TransitionPage(
          fullscreenDialog: true,
          style: TransitionStyle.fade,
          child: ImagePreviewPage(
            state.pathOrQuery('id'),
            index: int.parse(state.pathOrQuery('index', true)),
          ),
        ),
      ),
      route(
        friendship,
        pageBuilder: (_, state) => TransitionPage(
          child: UserFollowPage(
            state.pathOrQuery('id'),
            state.pathOrQuery('name', true),
            index: int.parse(state.pathOrQuery('index', true)),
          ),
        ),
      ),

      route(
        detail,
        pageBuilder: (_, state) {
          return TransitionPage(
            child: PostDetailsPage(state.pathOrQuery('id')),
          );
        },
      ),
      route(
        change,
        pageBuilder: (_, state) => TransitionPage(
          fullscreenDialog: true,
          style: TransitionStyle.bottomToTop,
          child: EditPostPage(state.pathOrQuery('id')),
        ),
      ),
      route(
        edit,
        pageBuilder: (_, state) => TransitionPage(
          fullscreenDialog: true,
          style: TransitionStyle.bottomToTop,
          child: EditProfilePage(state.pathOrQuery('id')),
        ),
      ),
    ],
    extraCodec: const JsonCodec(),
    errorBuilder: (_, sts) => PageLayout(
      content: Center(child: Text('No route for: ${sts.uri.toString()}')),
    ),
  );
}
