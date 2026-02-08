import 'package:semesta/public/helpers/feed_view.dart';
import 'package:semesta/public/helpers/generic_helper.dart';
import 'package:semesta/public/mixins/post_mixin.dart';
import 'package:semesta/public/utils/type_def.dart';
import 'package:semesta/app/models/feed.dart';
import 'package:semesta/app/repositories/repository.dart';
import 'package:semesta/public/helpers/class_helper.dart';
import 'package:semesta/public/helpers/utils_helper.dart';

class PostRepository extends IRepository<Feed> with PostMixin {
  AsWait insert(Feed model) async {
    assert(model.uid.isNotEmpty);

    final ref = collection(path);
    await execute((run) async {
      switch (model.type) {
        // ─────────────────────────────────────────────
        // COMMENT
        // ─────────────────────────────────────────────
        case Create.reply:
          assert(model.pid.isNotEmpty);

          final parentRef = ref.doc(model.pid);
          final childRef = parentRef.collection(comments).doc();
          final payload = model.copy(id: childRef.id, pid: parentRef.id).to();

          run.set(childRef, payload);
          run.update(parentRef, toggleStats(FeedKind.replied));
          break;

        // ─────────────────────────────────────────────
        // QUOTE (standalone post with reference)
        // ─────────────────────────────────────────────
        case Create.quote:
          assert(model.pid.isNotEmpty);

          final newRef = ref.doc();
          final parentRef = ref.doc(model.pid);
          final payload = model.copy(id: newRef.id, pid: model.pid).to();

          run.set(newRef, payload);
          run.update(parentRef, toggleStats(FeedKind.quoted));
          break;

        // ─────────────────────────────────────────────
        // ORIGINAL POST
        // ─────────────────────────────────────────────
        default:
          final newRef = ref.doc();
          final payload = model.copy(id: newRef.id).to();
          run.set(newRef, payload);
      }
    });
  }

  AsWait toggleReaction(
    ActionTarget target,
    String uid, [
    ActionType type = ActionType.like,
  ]) => switch (type) {
    ActionType.like => switch (target) {
      ParentTarget(:final pid) => toggle(pid, uid),
      ChildTarget(:final pid, :final cid) => subtoggle(pid, cid, uid),
    },
    ActionType.save => switch (target) {
      ParentTarget(:final pid) => toggle(
        pid,
        uid,
        subcol: bookmarks,
        kind: FeedKind.saved,
      ),
      ChildTarget(:final pid, :final cid) => subtoggle(
        pid,
        cid,
        uid,
        subcol: bookmarks,
        kind: FeedKind.saved,
      ),
    },
    ActionType.repost => switch (target) {
      ParentTarget(:final pid) => toggle(
        pid,
        uid,
        subcol: reposts,
        kind: FeedKind.reposted,
      ),
      ChildTarget(:final pid, :final cid) => subtoggle(
        pid,
        cid,
        uid,
        subcol: reposts,
        kind: FeedKind.reposted,
      ),
    },
  };

  AsWait destroyPost(Feed post, [String col = comments]) async {
    final id = post.id;
    final pid = post.pid;
    final ref = collection(path);

    await execute((run) async {
      switch (post.type) {
        case Create.quote:
          run.delete(ref.doc(id));
          run.update(ref.doc(pid), toggleStats(FeedKind.quoted, -1));
          break;

        case Create.reply:
          run.delete(ref.doc(pid).collection(col).doc(id));
          run.update(ref.doc(pid), toggleStats(FeedKind.replied, -1));
          break;

        default:
          run.delete(ref.doc(id));
      }
    });
  }

  AsWait modifyPost(Feed post, [String col = comments]) async {
    final id = post.id;
    final pid = post.pid;
    final ref = collection(path);

    await execute((run) async {
      switch (post.type) {
        case Create.reply:
          run.update(ref.doc(pid).collection(col).doc(id), post.to());
          break;

        default:
          run.update(ref.doc(id), post.to());
      }
    });
  }

  @override
  String get path => posts;

  @override
  Feed from(AsMap map) => Feed.from(map);

  @override
  AsMap to(Feed model) => model.to();
}
