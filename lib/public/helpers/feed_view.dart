import 'package:semesta/app/models/author.dart';
import 'package:semesta/app/models/feed.dart';
import 'package:semesta/app/models/reaction.dart';
import 'package:semesta/public/helpers/audit_view.dart';
import 'package:semesta/public/helpers/class_helper.dart';
import 'package:semesta/public/helpers/utils_helper.dart';

class FeedView implements HasAttributes {
  final String uid;
  final String rid; // unique per row

  final Feed feed;
  final Feed? parent;
  final Author? actor;
  final Reaction? action;
  final FeedKind kind;

  FeedView(
    this.feed, {
    this.parent,
    this.created,
    this.uid = '',
    this.rid = '',
    this.actor,
    this.action,
    this.kind = FeedKind.posted,
  }) : assert(feed.id.isNotEmpty, 'Feed View created with empty ${feed.id}');

  @override
  final DateTime? created;

  @override
  String get currentId => rid;

  @override
  String get targetId => uid;

  bool get allowed {
    return kind == FeedKind.replied ||
        kind == FeedKind.posted ||
        kind == FeedKind.following;
  }

  FeedView copy({
    Feed? feed,
    String? uid,
    String? rid,
    Feed? parent,
    Author? actor,
    FeedKind? kind,
    Reaction? action,
    DateTime? created,
  }) => FeedView(
    feed ?? this.feed,
    uid: uid ?? this.uid,
    rid: rid ?? this.rid,
    kind: kind ?? this.kind,
    actor: actor ?? this.actor,
    parent: parent ?? this.parent,
    action: action ?? this.action,
    created: created ?? this.created,
  );

  factory FeedView.from(
    Feed state, {
    String? uid,
    Reaction? action,
    FeedKind kind = FeedKind.posted,
  }) => FeedView(
    state,
    action: action,
    rid: getRowId(
      pid: state.id,
      uid: uid ?? state.uid,
      kind: action?.kind ?? kind,
    ),
    uid: uid ?? action?.targetId ?? state.uid,
    kind: action?.kind ?? kind,
    created: action?.createdAt ?? state.createdAt,
  );
}

class FeedStateView {
  final StatusView status;
  final FeedView content;
  final ActionsView actions;
  const FeedStateView({
    required this.actions,
    required this.status,
    required this.content,
  });
}

class StateView {
  final StatusView status;
  final ActionsView actions;
  const StateView(this.status, this.actions);
}
