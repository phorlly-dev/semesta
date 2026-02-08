import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:semesta/public/helpers/feed_view.dart';
import 'package:semesta/public/helpers/generic_helper.dart';
import 'package:semesta/public/utils/type_def.dart';

enum Screen {
  home,
  detail,
  following,
  bookmark,
  post,
  quote,
  comment,
  media,
  favorite,
}

String getKey({String id = '', Screen screen = Screen.home}) {
  return switch (screen) {
    Screen.home => 'home:all',
    Screen.quote => 'post:$id:quotes',
    Screen.post => 'profile:$id:$posts',
    Screen.media => 'profile:$id:media',
    Screen.detail => 'post:$id:details',
    Screen.comment => 'profile:$id:$comments',
    Screen.favorite => 'user:$id:$favorites',
    Screen.bookmark => 'user:$id:$bookmarks',
    Screen.following => 'home:$id:$following',
  };
}

///Update Stats
AsMap toggleStats(FeedKind key, [int value = 1]) => {
  'stats.${key.name}': FieldValue.increment(value),
};
