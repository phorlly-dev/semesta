import 'package:semesta/core/mixins/router_mixin.dart';
import 'package:semesta/app/utils/params.dart';

class Routes with RouterMixin {
  //pages inside
  RouteParams get home => RouteParams(path: convert('home'), name: 'home');
  RouteParams get explore =>
      RouteParams(path: convert('explore'), name: 'explore');
  RouteParams get reel => RouteParams(path: convert('reel'), name: 'reel');
  RouteParams get notify =>
      RouteParams(path: convert('notify'), name: 'notify');
  RouteParams get messsage =>
      RouteParams(path: convert('messsage'), name: 'messsage');

  //pages outside
  RouteParams get splash =>
      RouteParams(path: convert('splash'), name: 'splash');
  RouteParams get auth => RouteParams(path: convert('auth'), name: 'auth');

  RouteParams get userBookmark =>
      RouteParams(path: convert('users/:id/bookmark'), name: 'posts.bookmark');
  RouteParams get profile =>
      RouteParams(path: convert('users/:id/profile'), name: 'users.profile');
  RouteParams get avatarPreview => RouteParams(
    path: convert('users/avatar/:id/preview'),
    name: 'users.avatar.preview',
  );
  RouteParams get friendship => RouteParams(
    path: convert('users/:id/friendship'),
    name: 'users.friendship',
  );

  RouteParams get createPost =>
      RouteParams(path: convert('posts/create'), name: 'posts.create');
  RouteParams get replyPost =>
      RouteParams(path: convert('posts/:id/reply'), name: 'posts.reply');
  RouteParams get repost =>
      RouteParams(path: convert('posts/:id/repost'), name: 'posts.repost');
  RouteParams get videoPreview => RouteParams(
    path: convert('posts/videos/:id/preview'),
    name: 'posts.videos.preview',
  );
  RouteParams get imagesPreview => RouteParams(
    path: convert('posts/images/:id/previews'),
    name: 'posts.images.preview',
  );
  RouteParams get postDatails =>
      RouteParams(path: convert('posts/:id/detail'), name: 'posts.detail');

  //path menu
  List<String> get paths => [
    explore.path,
    reel.path,
    home.path,
    notify.path,
    messsage.path,
  ];

  List<String> get titles => [
    'Semesta',
    reel.name,
    explore.name,
    notify.name,
    messsage.name,
  ];

  int getIndexFromLocation(String location) =>
      paths.indexWhere((p) => location.startsWith(p));
}
