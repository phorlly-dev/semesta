import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:semesta/app/routes/router_refresh_stream.dart';
import 'package:semesta/app/routes/routes.dart';
import 'package:semesta/app/utils/transition_page.dart';
import 'package:semesta/core/controllers/action_controller.dart';
import 'package:semesta/core/controllers/auth_controller.dart';
import 'package:semesta/core/controllers/post_controller.dart';
import 'package:semesta/core/models/post_model.dart';
import 'package:semesta/core/models/user_model.dart';
import 'package:semesta/ui/pages/create_post_page.dart';
import 'package:semesta/ui/pages/post_details_page.dart';
import 'package:semesta/ui/pages/image_preview_page.dart';
import 'package:semesta/ui/pages/reply_to_post_page.dart';
import 'package:semesta/ui/pages/repost_post_page.dart';
import 'package:semesta/ui/pages/profile_view_page.dart';
import 'package:semesta/ui/pages/avatar_preview_page.dart';
import 'package:semesta/ui/screens/message_screen.dart';
import 'package:semesta/ui/pages/auth_page.dart';
import 'package:semesta/ui/screens/explore_screen.dart';
import 'package:semesta/ui/screens/home_screen.dart';
import 'package:semesta/ui/pages/saved_views_page.dart';
import 'package:semesta/ui/components/global/index.dart';
import 'package:semesta/ui/screens/notifications_screen.dart';
import 'package:semesta/ui/pages/splash_page.dart';
import 'package:semesta/ui/screens/reels_screen.dart';

class AppRouter extends Routes {
  final _auth = Get.find<AuthController>();
  String get uid => _auth.currentUser.value?.uid ?? '';
  static final appReady = ValueNotifier<bool>(false);
  final rootNavKey = GlobalKey<NavigatorState>();

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
      goRoute(splash, builder: (ctx, sts) => SplashPage()),
      goRoute(auth, builder: (ctx, sts) => AuthPage(controller: _auth)),

      // Shell (tabs)
      StatefulShellRoute.indexedStack(
        builder: (context, state, shell) {
          Get.put(PostController());
          Get.put(ActionController());
          return AppLayout(child: shell);
        },
        branches: [
          branch(home, child: HomeScreen()),
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
          final userId = state.pathParameters['id'];
          final postId = state.uri.queryParameters['parent'];
          if (userId == null) {
            throw Exception('Invalid user ID in post: $userId');
          }

          return TransitionPage(
            child: ProfileViewPage(userId: userId, postId: postId ?? ''),
          );
        },
      ),
      goRoute(
        postsSaved,
        pageBuilder: (context, state) {
          final userId = state.pathParameters['id'];
          if (userId == null) {
            throw Exception('Invalid user ID in post: $userId');
          }

          return TransitionPage(child: SavedViewsPage(userId: userId));
        },
      ),
      goRoute(
        avatarPreview,
        pageBuilder: (context, state) {
          final userId = state.pathParameters['id']!;
          final isOwner = bool.parse(state.uri.queryParameters['self']!);

          return TransitionPage(
            child: AvatarPreviewPage(userId: userId, isOwner: isOwner),
            fullscreenDialog: true,
          );
        },
      ),
      goRoute(
        createPost,
        pageBuilder: (context, state) =>
            TransitionPage(child: CreatePostPage(), fullscreenDialog: true),
      ),
      goRoute(
        replyPost,
        pageBuilder: (context, state) {
          final postId = state.pathParameters['id'];
          if (postId == null) {
            throw Exception('Invalid post ID: $postId');
          }

          return TransitionPage(
            child: ReplyToPostPage(postId: postId),
            fullscreenDialog: true,
          );
        },
      ),
      goRoute(
        repost,
        pageBuilder: (context, state) {
          final postId = state.pathParameters['id'];
          if (postId == null) {
            throw Exception('Invalid post ID: $postId');
          }

          return TransitionPage(
            child: PostRepost(postId: postId),
            fullscreenDialog: true,
          );
        },
      ),
      goRoute(
        imagesPreview,
        pageBuilder: (context, state) {
          final postId = state.pathParameters['id']!;

          return TransitionPage(
            child: ImagePreviewPage(postId: postId),
            fullscreenDialog: true,
          );
        },
      ),
      goRoute(
        postDatails,
        pageBuilder: (context, state) {
          final args = state.extra as Map<String, dynamic>;
          final user = args['user'] as UserModel;
          final post = args['post'] as PostModel;

          return TransitionPage(
            child: PostDetailsPage(user: user, post: post),
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
