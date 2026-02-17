import 'package:semesta/app/models/feed.dart';
import 'package:semesta/app/models/reaction.dart';
import 'package:semesta/public/extensions/model_extension.dart';
import 'package:semesta/public/helpers/audit_view.dart';
import 'package:semesta/public/helpers/class_helper.dart';

enum FeedKind {
  posts,
  reposts,
  quotes,
  replies,
  likes,
  saves,
  media,
  views,
  shares,
  following,
  followers,
}

class FeedView implements HasAttributes {
  final String uid;
  final String rid; // unique per row

  final Feed feed;
  final Reaction? action;
  final FeedKind kind;

  FeedView(
    this.feed, {
    this.created,
    this.uid = '',
    this.rid = '',
    this.action,
    this.kind = FeedKind.posts,
  }) : assert(feed.id.isNotEmpty, 'Feed View created with empty ${feed.id}');

  @override
  final DateTime? created;

  @override
  String get currentId => rid;

  @override
  String get targetId => uid;

  FeedView copyWith({
    Feed? feed,
    String? uid,
    String? rid,
    FeedKind? kind,
    Reaction? action,
    DateTime? created,
  }) => FeedView(
    feed ?? this.feed,
    uid: uid ?? this.uid,
    rid: rid ?? this.rid,
    kind: kind ?? this.kind,
    action: action ?? this.action,
    created: created ?? this.created,
  );

  factory FeedView.fromState(
    Feed payload, {
    String? uid,
    Reaction? action,
    FeedKind kind = FeedKind.posts,
  }) => FeedView(
    payload,
    action: action,
    rid: payload.toId(puid: uid ?? payload.uid, kind: action?.kind ?? kind),
    uid: uid ?? action?.did ?? payload.uid,
    kind: action?.kind ?? kind,
    created: action?.createdAt ?? payload.createdAt,
  );
}

class FeedStateView {
  final StatusView status;
  final FeedView content;
  final ActionsView actions;
  const FeedStateView(this.status, this.content, this.actions);
}

class StateView {
  final StatusView status;
  final ActionsView actions;
  const StateView(this.status, this.actions);
}
