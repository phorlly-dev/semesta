import 'package:semesta/core/models/feed.dart';
import 'package:semesta/core/views/audit_view.dart';
import 'package:semesta/core/views/helper.dart';

class FeedView implements HasAttributes {
  final String uid;
  final String rid; // unique per row

  final Feed feed;
  final Feed? parent;
  final FeedKind kind;

  FeedView({
    required this.feed,
    this.parent,
    this.created,
    this.uid = '',
    this.rid = '',
    this.kind = FeedKind.post,
  }) : assert(feed.id.isNotEmpty, 'Feed View created with empty feed.id');

  @override
  final DateTime? created;

  @override
  String get currentId => rid;

  @override
  String get targetId => uid;

  bool get hasQuote => kind == FeedKind.quote;
  bool get hasComment => kind == FeedKind.comment;
  bool get hasRepost => kind == FeedKind.repost;

  FeedView copy({
    Feed? feed,
    Feed? parent,
    FeedKind? kind,
    String? uid,
    String? rid,
    DateTime? created,
  }) {
    return FeedView(
      uid: uid ?? this.uid,
      rid: rid ?? this.rid,
      feed: feed ?? this.feed,
      parent: parent ?? this.parent,
      kind: kind ?? this.kind,
      created: created ?? this.created,
    );
  }

  factory FeedView.from(
    Feed state, {
    String? uid,
    FeedKind type = FeedKind.post,
  }) {
    return FeedView(
      feed: state,
      uid: uid ?? state.uid,
      kind: type,
      created: state.createdAt,
      rid: buildRowId(pid: state.pid, kind: type, uid: uid ?? state.uid),
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
