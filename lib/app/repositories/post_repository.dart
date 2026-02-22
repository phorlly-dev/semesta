import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:semesta/public/helpers/feed_view.dart';
import 'package:semesta/public/helpers/generic_helper.dart';
import 'package:semesta/public/mixins/post_mixin.dart';
import 'package:semesta/public/utils/type_def.dart';
import 'package:semesta/app/models/feed.dart';
import 'package:semesta/app/repositories/repository.dart';
import 'package:semesta/public/helpers/class_helper.dart';

class PostRepository extends IRepository<Feed> with PostMixin {
  AsWait insert(Feed model) async {
    assert(model.uid.isNotEmpty);

    final id = model.pid;
    switch (model.type) {
      // ─────────────────────────────────────────────
      // ORIGINAL POST
      // ─────────────────────────────────────────────
      case Create.post:
        final newRef = _ref();
        final payload = model.copyWith(id: newRef.id).toPayload();
        await newRef.set(payload);
        break;

      // ─────────────────────────────────────────────
      // QUOTE (standalone post with reference)
      // ─────────────────────────────────────────────
      case Create.quote:
        assert(id.isNotEmpty);

        final newRef = _ref();
        final payload = model.copyWith(id: newRef.id).toPayload();
        await newRef.set(payload);
        break;

      // ─────────────────────────────────────────────
      // COMMENT
      // ─────────────────────────────────────────────
      case Create.reply:
        assert(id.isNotEmpty);

        final newRef = _ref(id).collection(comments).doc();
        final payload = model.copyWith(id: newRef.id).toPayload();
        await newRef.set(payload);
        break;
    }
  }

  AsWait toggleReaction(
    ActionTarget target, [
    ActionType type = ActionType.like,
  ]) => switch (type) {
    ActionType.like => switch (target) {
      ParentTarget(:final pid) => callable('onToggle', {
        'props': {keyId: pid, postId: null, 'name': FeedKind.likes.name},
      }),
      ChildTarget(:final pid, :final cid) => callable('onToggle', {
        'props': {keyId: cid, postId: pid, 'name': FeedKind.likes.name},
      }),
    },
    ActionType.save => switch (target) {
      ParentTarget(:final pid) => callable('onToggle', {
        'props': {keyId: pid, postId: null, 'name': FeedKind.saves.name},
      }),
      ChildTarget(:final pid, :final cid) => callable('onToggle', {
        'props': {keyId: cid, postId: pid, 'name': FeedKind.saves.name},
      }),
    },
    ActionType.repost => switch (target) {
      ParentTarget(:final pid) => callable('onToggle', {
        'props': {keyId: pid, postId: null, 'name': FeedKind.reposts.name},
      }),
      ChildTarget(:final pid, :final cid) => callable('onToggle', {
        'props': {keyId: cid, postId: pid, 'name': FeedKind.reposts.name},
      }),
    },
  };

  AsWait destroyPost(Feed post, [String col = comments]) {
    final id = post.id;
    final pid = post.pid;
    final docRef = _ref(id).delete();

    clearCached(id);
    return switch (post.type) {
      Create.post => docRef,
      Create.quote => docRef,
      Create.reply => _ref(pid).collection(col).doc(id).delete(),
    };
  }

  AsWait modifyPost(Feed post, [String col = comments]) {
    final id = post.id;
    final pid = post.pid;
    final docRef = _ref(id).update(post.toPayload());

    clearCached(id);
    return switch (post.type) {
      Create.post => docRef,
      Create.quote => docRef,
      Create.reply => _ref(
        pid,
      ).collection(col).doc(id).update(post.toPayload()),
    };
  }

  DocumentReference<AsMap> _ref([String? path]) {
    return collection(colName).doc(path);
  }

  @override
  String get colName => posts;

  @override
  Feed fromState(AsMap map) => Feed.fromState(map);

  @override
  AsMap toPayload(Feed model) => model.toPayload();
}
