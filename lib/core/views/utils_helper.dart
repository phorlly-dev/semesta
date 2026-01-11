import 'package:semesta/app/extensions/model_extension.dart';
import 'package:semesta/app/utils/params.dart';
import 'package:semesta/app/utils/type_def.dart';
import 'package:semesta/core/models/author.dart';
import 'package:semesta/core/models/feed.dart';
import 'package:semesta/core/models/reaction.dart';
import 'package:semesta/core/views/audit_view.dart';
import 'package:semesta/core/views/class_helper.dart';
import 'package:semesta/core/views/feed_view.dart';
import 'package:semesta/core/views/generic_helper.dart';

enum FeedKind {
  post,
  repost,
  quote,
  comment,
  favorite,
  bookmark,
  media,
  share,
  following,
  follower,
}

String getRowId({
  FeedKind kind = FeedKind.post,
  required String pid,
  String uid = '',
}) {
  switch (kind) {
    case FeedKind.repost:
      return 'r:$uid:$pid';

    case FeedKind.favorite:
      return 'f:$uid:$pid';

    case FeedKind.bookmark:
      return 'b:$uid:$pid';

    case FeedKind.media:
      return 'm:$uid:$pid';

    case FeedKind.share:
      return 's:$uid:$pid';

    case FeedKind.comment:
      return 'c:$uid:$pid';

    case FeedKind.quote:
      return 'q:$pid';

    default:
      return 'p:$pid';
  }
}

enum KindTab { posts, media, favorites }

CountState countState(int value, [KindTab kind = KindTab.posts]) {
  switch (kind) {
    case KindTab.favorites:
      return CountState(value == 1 ? 'like' : 'likes', value);

    case KindTab.media:
      return CountState('media', value);

    default:
      return CountState(value == 1 ? 'post' : posts, value);
  }
}

enum Screen { home, following, bookmark, post, comment, media, favorite }

String getKey({String uid = '', Screen screen = Screen.home}) {
  switch (screen) {
    case Screen.following:
      return 'home:$following';

    case Screen.media:
      return 'profile:$uid:media';

    case Screen.post:
      return 'profile:$uid:$posts';

    case Screen.favorite:
      return 'profile:$uid:$favorites';

    case Screen.comment:
      return 'profile:$uid:$comments';

    case Screen.bookmark:
      return 'user:$uid:$bookmarks';

    default:
      return 'home:all';
  }
}

bool isComment(Feed f) => f.type == Create.comment && f.pid.isNotEmpty;
String feedPath(Feed f) {
  if (isComment(f)) {
    return '${f.pid}/$comments/${f.id}';
  }

  return f.id;
}

String repostPath(ActionTarget target, String uid) {
  switch (target) {
    case FeedTarget(:final pid):
      return '$pid/$reposts/$uid';

    case CommentTarget(:final pid, :final cid):
      return '$pid/$comments/$cid/$reposts/$uid';
  }
}

List<FeedView> mapToFeed(
  List<Feed> feeds, {
  String? uid,
  FeedKind type = FeedKind.post,
  List<Reaction> actions = const [],
}) {
  return feeds.map((feed) {
    final action = reactionsBy(actions, (value) => value.currentId)[feed.id];
    return FeedView.from(feed, kind: type, action: action, uid: uid);
  }).toList();
}

List<AuthedView> mapToFollow(
  List<Author> users,
  List<Reaction> reactions,
  PropsCallback<Reaction, String> selector,
) {
  return users
      .map((user) {
        final action = reactionsBy(reactions, selector)[user.id];
        if (action == null) return null;

        return AuthedView(user, action);
      })
      .whereType<AuthedView>()
      .toList();
}

bool canNavigateTo(String targetUserId, [String? viewedProfileId]) {
  if (viewedProfileId == null) return true;
  return targetUserId != viewedProfileId;
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

Map<String, Reaction> reactionsBy(
  List<Reaction> actions,
  PropsCallback<Reaction, String> selector,
) => {for (final action in actions) selector(action): action};

List<FeedView> mapToFeeds(List<Feed> feeds, [String? uid]) {
  return feeds
      .map((post) {
        if (post.hasQuote) {
          return FeedView(
            feed: post,
            kind: FeedKind.quote,
            uid: uid ?? post.uid,
            created: post.createdAt,
            parent: pctrl.dataMapping[post.pid],
            rid: getRowId(kind: FeedKind.quote, pid: post.id),
          );
        }

        return FeedView(
          feed: post,
          uid: uid ?? post.uid,
          created: post.createdAt,
          rid: getRowId(pid: post.id),
        );
      })
      .whereType<FeedView>()
      .toList();
}

AsList getKeys(
  List<Reaction> actions,
  PropsCallback<Reaction, String> selector,
) => actions.map(selector).toSet().toList();
