import 'package:semesta/public/extensions/model_extension.dart';
import 'package:semesta/public/utils/params.dart';
import 'package:semesta/app/models/author.dart';
import 'package:semesta/app/models/feed.dart';
import 'package:semesta/public/helpers/class_helper.dart';
import 'package:semesta/public/helpers/generic_helper.dart';

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
  FeedKind kind = FeedKind.posted,
  required String pid,
  String uid = '',
}) {
  switch (kind) {
    case FeedKind.reposted:
      return 'r:$uid:$pid';

    case FeedKind.liked:
      return 'f:$uid:$pid';

    case FeedKind.saved:
      return 'b:$uid:$pid';

    case FeedKind.media:
      return 'm:$uid:$pid';

    case FeedKind.shared:
      return 's:$uid:$pid';

    case FeedKind.replied:
      return 'c:$uid:$pid';

    case FeedKind.quoted:
      return 'q:$pid';

    default:
      return 'p:$pid';
  }
}

CountState countState(int value, [FeedKind kind = FeedKind.posted]) {
  switch (kind) {
    case FeedKind.liked:
      return CountState(
        value == 1 ? 'Like' : 'Likes',
        value,
        kind: FeedKind.liked,
      );

    case FeedKind.viewed:
      return CountState(
        value == 1 ? 'View' : 'Views',
        value,
        kind: FeedKind.viewed,
      );

    case FeedKind.following:
      return CountState('Following', value, kind: FeedKind.following);

    case FeedKind.follower:
      return CountState(
        value == 1 ? 'Follower' : 'Followers',
        value,
        kind: FeedKind.follower,
      );

    case FeedKind.quoted:
      return CountState(
        value == 1 ? 'Quote' : 'Quotes',
        value,
        kind: FeedKind.quoted,
      );

    case FeedKind.reposted:
      return CountState(
        value == 1 ? 'Repost' : 'Reposts',
        value,
        kind: FeedKind.reposted,
      );

    case FeedKind.saved:
      return CountState(
        value == 1 ? 'Save' : 'Saves',
        value,
        kind: FeedKind.saved,
      );

    case FeedKind.shared:
      return CountState(
        value == 1 ? 'Share' : 'Shares',
        value,
        kind: FeedKind.shared,
      );

    case FeedKind.media:
      return CountState('Media', value, kind: FeedKind.media);

    default:
      return CountState(value == 1 ? 'Post' : 'Posts', value);
  }
}

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
  switch (screen) {
    case Screen.media:
      return 'profile:$id:media';

    case Screen.post:
      return 'profile:$id:$posts';

    case Screen.comment:
      return 'profile:$id:$comments';

    case Screen.favorite:
      return 'user:$id:$favorites';

    case Screen.bookmark:
      return 'user:$id:$bookmarks';

    case Screen.detail:
      return 'post:$id:details';

    case Screen.following:
      return 'home:$id:$following';

    default:
      return 'home:all';
  }
}

String feedPath(Feed f) => f.hasComment ? '${f.pid}/$comments/${f.id}' : f.id;

ActionTarget getTarget(Feed f) {
  return f.hasComment ? ChildTarget(f.pid, f.id) : ParentTarget(f.id);
}

String repostPath(ActionTarget target, String uid) {
  switch (target) {
    case ParentTarget(:final pid):
      return '$pid/$reposts/$uid';

    case ChildTarget(:final pid, :final cid):
      return '$pid/$comments/$cid/$reposts/$uid';
  }
}

bool canNavigateTo(String targetUid, [String? viewedUid]) {
  if (viewedUid == null) return true;
  return targetUid != viewedUid;
}

Follow resolveState(bool iFollow, bool theyFollow) {
  if (iFollow) {
    return Follow.following;
  } else if (!iFollow && theyFollow) {
    return Follow.followBack;
  } else {
    return Follow.follow;
  }
}

String getkey(ActionTarget target) {
  return switch (target) {
    ParentTarget(:final pid) => 'p:$pid',
    ChildTarget(:final pid, :final cid) => 'c:$pid:$cid',
  };
}
