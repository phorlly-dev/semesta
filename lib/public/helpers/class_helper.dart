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
