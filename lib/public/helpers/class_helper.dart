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

class ParentTarget extends ActionTarget {
  final String pid;
  const ParentTarget(this.pid);
}

class ChildTarget extends ActionTarget {
  final String pid;
  final String cid;
  const ChildTarget(this.pid, this.cid);
}
