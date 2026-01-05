import 'package:semesta/core/models/author.dart';
import 'package:semesta/core/models/feed.dart';
import 'package:semesta/core/views/feed_view.dart';
import 'package:semesta/core/views/helper.dart';

class AuthedView implements HasAttributes {
  final Author author;
  const AuthedView(this.author);

  @override
  String get currentId => author.id;

  @override
  DateTime? get created => author.createdAt;

  @override
  String get targetId => author.uname;
}

class StatusView {
  final Author author;
  final Author? actor;
  final bool authed;
  final bool iFollow;
  final bool theyFollow;
  const StatusView({
    required this.author,
    this.authed = false,
    this.iFollow = false,
    this.theyFollow = false,
    this.actor,
  });

  StatusView copy({
    Author? author,
    Author? actor,
    bool? authed,
    bool? iFollow,
    bool? theyFollow,
  }) {
    return StatusView(
      author: author ?? this.author,
      actor: actor ?? this.actor,
      authed: authed ?? this.authed,
      iFollow: iFollow ?? this.iFollow,
      theyFollow: theyFollow ?? this.theyFollow,
    );
  }
}

class ActionsView {
  final String pid;
  final ActionTarget target;

  final bool favorited;
  final bool bookmarked;
  final bool reposted;

  final int favorites;
  final int bookmarks;
  final int reposts;
  final int views;
  final int comments;
  final int shares;

  const ActionsView({
    required this.pid,
    required this.target,
    required this.favorited,
    required this.bookmarked,
    required this.reposted,
    required this.favorites,
    required this.bookmarks,
    required this.reposts,
    required this.views,
    required this.comments,
    required this.shares,
  });
}

List<FeedView> mapToFeed(
  List<Feed> feeds, {
  String? uid,
  FeedKind type = FeedKind.post,
}) {
  return feeds.map((feed) {
    return FeedView.from(feed, type: type, uid: uid);
  }).toList();
}
