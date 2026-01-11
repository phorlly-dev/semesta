import 'package:semesta/core/models/author.dart';
import 'package:semesta/core/models/feed.dart';
import 'package:semesta/core/models/reaction.dart';
import 'package:semesta/core/views/audit_view.dart';
import 'package:semesta/core/views/class_helper.dart';
import 'package:semesta/core/views/utils_helper.dart';

class FeedView implements HasAttributes {
  final String uid;
  final String rid; // unique per row

  final Feed feed;
  final Feed? parent;
  final Author? actor;
  final Reaction? action;
  final FeedKind kind;

  FeedView({
    required this.feed,
    this.parent,
    this.created,
    this.uid = '',
    this.rid = '',
    this.actor,
    this.action,
    this.kind = FeedKind.post,
  }) : assert(feed.id.isNotEmpty, 'Feed View created with empty ${feed.id}');

  @override
  final DateTime? created;

  @override
  String get currentId => rid;

  @override
  String get targetId => uid;

  bool get allowed => kind == FeedKind.comment || kind == FeedKind.post;

  FeedView copy({
    Feed? feed,
    String? uid,
    String? rid,
    Feed? parent,
    Author? actor,
    FeedKind? kind,
    Reaction? action,
    DateTime? created,
  }) {
    return FeedView(
      uid: uid ?? this.uid,
      rid: rid ?? this.rid,
      feed: feed ?? this.feed,
      kind: kind ?? this.kind,
      actor: actor ?? this.actor,
      parent: parent ?? this.parent,
      action: action ?? this.action,
      created: created ?? this.created,
    );
  }

  factory FeedView.from(
    Feed state, {
    String? uid,
    Reaction? action,
    FeedKind kind = FeedKind.post,
  }) {
    return FeedView(
      feed: state,
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

class CommentView {
  final Feed feed;
  final StatusView status;
  final ActionsView actions;
  const CommentView({
    required this.feed,
    required this.status,
    required this.actions,
  });
}
