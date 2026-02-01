import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:semesta/public/extensions/model_extension.dart';
import 'package:semesta/app/models/feed.dart';
import 'package:semesta/public/helpers/class_helper.dart';
import 'package:semesta/public/helpers/generic_helper.dart';
import 'package:semesta/public/utils/type_def.dart';

enum FeedKind {
  posted,
  reposted,
  quoted,
  replied,
  liked,
  saved,
  media,
  viewed,
  shared,
  following,
  follower,
}

String getRowId({
  required String pid,
  String uid = '',
  FeedKind kind = FeedKind.posted,
}) => switch (kind) {
  FeedKind.quoted => 'q:$pid',
  FeedKind.posted => 'p:$pid',
  FeedKind.viewed => 'v:$pid',
  FeedKind.follower => 'fr:$uid',
  FeedKind.following => 'fi:$uid',
  FeedKind.saved => 'b:$uid:$pid',
  FeedKind.media => 'm:$uid:$pid',
  FeedKind.liked => 'l:$uid:$pid',
  FeedKind.shared => 's:$uid:$pid',
  FeedKind.replied => 'c:$uid:$pid',
  FeedKind.reposted => 'r:$uid:$pid',
};

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

String feedPath(Feed f) => f.hasComment ? '${f.pid}/$comments/${f.id}' : f.id;

ActionTarget getTarget(Feed f) {
  return f.hasComment ? ChildTarget(f.pid, f.id) : ParentTarget(f.id);
}

String repostPath(ActionTarget target, String uid) {
  return switch (target) {
    ParentTarget(:final pid) => '$pid/$reposts/$uid',
    ChildTarget(:final pid, :final cid) => '$pid/$comments/$cid/$reposts/$uid',
  };
}

String getkey(ActionTarget target) {
  return switch (target) {
    ParentTarget(:final pid) => 'p:$pid',
    ChildTarget(:final pid, :final cid) => 'c:$pid:$cid',
  };
}

///Stat Incrementer
AsMap incrementStat(FeedKind key, [int by = 1]) => {
  'stats.${key.name}': FieldValue.increment(by),
};
