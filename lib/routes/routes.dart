import 'package:flutter/material.dart';
import 'package:semesta/public/helpers/params_helper.dart';
import 'package:semesta/routes/cached_routes.dart';
import 'package:semesta/public/utils/type_def.dart';

class Routes extends ICachedRoutes
    with IScreenRoutes, IUserRoutes, IPostRoutes {
  // root (absolute)
  @override
  RouteNode get home => cached(() => const RouteNode('/home', 'home'));

  @override
  RouteNode get explore {
    return cached(() => const RouteNode('/explores', 'explores'));
  }

  @override
  RouteNode get messsage {
    return cached(() => const RouteNode('/messsages', 'messsages'));
  }

  @override
  RouteNode get notify {
    return cached(() => const RouteNode('/notifications', 'notifications'));
  }

  @override
  RouteNode get reel => cached(() => const RouteNode('/reels', 'reels'));

  // //Outside
  @override
  RouteNode get auth => cached(() => const RouteNode('/auth', 'auth'));

  @override
  RouteNode get splash => cached(() => const RouteNode('/splash', 'splash'));

  //path menu
  @override
  AsList get paths => [
    explore.path,
    reel.path,
    home.path,
    notify.path,
    messsage.path,
  ];

  @override
  AsList get titles => [
    'Semesta',
    reel.name,
    explore.name,
    notify.name,
    messsage.name,
  ];

  @override
  List<BottomNavigationBarItem> get items => [
    item(Icons.search, 'Explore'),
    item(Icons.ondemand_video_rounded, 'Reels'),
    item(Icons.home, 'Home'),
    item(Icons.notifications_none, 'Notifications'),
    item(Icons.email_outlined, 'Messages'),
  ];

  ///User routes
  @override
  RouteNode get avatar => user.child('avatar', 'avatar');

  @override
  RouteNode get bookmark => user.child('saved', 'saved');

  @override
  RouteNode get edit => user.child('edit', 'edit');

  @override
  RouteNode get favorite => user.child('liked', 'liked');

  @override
  RouteNode get friendship => user.child('follow', 'follow');

  @override
  RouteNode get profile => user.child('profile', 'profile');

  @override
  RouteNode get user => cached(() => const RouteNode('/user/:id', 'user'));

  ///Post routes
  @override
  RouteNode get change => posts.child('edit', 'edit');

  @override
  RouteNode get comment => posts.child('reply', 'reply');

  @override
  RouteNode get create {
    return cached(() => const RouteNode('/post/create', 'post.create'));
  }

  @override
  RouteNode get media => posts.child('media', 'media');

  @override
  RouteNode get detail => posts.child('detail', 'detail');

  @override
  RouteNode get posts => cached(() => const RouteNode('/posts/:id', 'posts'));

  @override
  RouteNode get repost => posts.child('repost', 'repost');
}
