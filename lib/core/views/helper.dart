import 'package:semesta/app/utils/params.dart';

class TabMeta {
  bool dirty = false;
}

abstract class HasAttributes {
  String get currentId;
  String get targetId;
  DateTime? get created;
}

sealed class ActionTarget {
  const ActionTarget();
}

class FeedTarget extends ActionTarget {
  final String pid;
  const FeedTarget(this.pid);
}

class CommentTarget extends ActionTarget {
  final String pid;
  final String cid;
  const CommentTarget(this.pid, this.cid);
}

enum FeedKind { post, repost, quote, comment, favorite, bookmark, media, share }

String buildRowId({
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
      return CountState(value == 1 ? 'post' : 'posts', value);
  }
}

class RepostView {
  final bool reposted, authed;
  final String uid, name;
  const RepostView({
    this.reposted = false,
    this.authed = false,
    this.uid = '',
    this.name = '',
  });
}
