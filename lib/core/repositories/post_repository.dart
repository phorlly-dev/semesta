import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:semesta/app/functions/logger.dart';
import 'package:semesta/core/views/generic_helper.dart';
import 'package:semesta/core/mixins/post_mixin.dart';
import 'package:semesta/app/utils/type_def.dart';
import 'package:semesta/core/models/feed.dart';
import 'package:semesta/core/repositories/repository.dart';
import 'package:semesta/core/views/class_helper.dart';
import 'package:semesta/core/views/utils_helper.dart';

class PostRepository extends IRepository<Feed> with PostMixin {
  Future<void> insert(Feed model) async {
    assert(model.uid.isNotEmpty);

    try {
      await db.runTransaction((txs) async {
        switch (model.type) {
          // ─────────────────────────────────────────────
          // COMMENT
          // ─────────────────────────────────────────────
          case Create.comment:
            assert(model.pid.isNotEmpty);

            final parentRef = collection(path).doc(model.pid);
            final commentRef = parentRef.collection(comments).doc();

            final comment = model.copy(id: commentRef.id, pid: parentRef.id);
            txs
              ..set(commentRef, comment.to())
              ..update(parentRef, {
                countKey(comments): FieldValue.increment(1),
              });
            break;

          // ─────────────────────────────────────────────
          // QUOTE (standalone post with reference)
          // ─────────────────────────────────────────────
          case Create.quote:
            assert(model.pid.isNotEmpty);

            final quoteRef = collection(path).doc();
            final parentRef = collection(path).doc(model.pid);

            final quote = model.copy(id: quoteRef.id, pid: model.pid);
            txs
              ..set(quoteRef, quote.to())
              ..update(parentRef, {countKey(): FieldValue.increment(1)});
            break;

          // ─────────────────────────────────────────────
          // ORIGINAL POST
          // ─────────────────────────────────────────────
          default:
            final postRef = collection(path).doc();
            txs.set(postRef, model.copy(id: postRef.id).to());
        }
      });
    } catch (e, s) {
      HandleLogger.error('Failed to create', message: e, stack: s);
      rethrow;
    }
  }

  Future<void> clearAllBookmarks(String uid, [String key = targetId]) async {
    final query = await subcollection(
      bookmarks,
    ).where(key, isEqualTo: uid).get();

    if (query.docs.isEmpty) return;

    final batch = db.batch();
    for (final doc in query.docs) {
      batch.delete(doc.reference);
    }

    await batch.commit();
  }

  Future<void> toggleFavorite(ActionTarget target, String uid) async {
    switch (target) {
      case FeedTarget(:final pid):
        await toggle(pid, uid);
        break;

      case CommentTarget(:final pid, :final cid):
        await subtoggle(pid, cid, uid);
        break;
    }
  }

  Future<void> toggleRepost(ActionTarget target, String uid) async {
    switch (target) {
      case FeedTarget(:final pid):
        await toggle(
          pid,
          uid,
          key: reposts,
          subcol: reposts,
          kind: FeedKind.repost,
        );
        break;

      case CommentTarget(:final pid, :final cid):
        await subtoggle(
          pid,
          cid,
          uid,
          key: reposts,
          subcol: reposts,
          kind: FeedKind.repost,
        );
        break;
    }
  }

  Future<void> toggleBookmark(ActionTarget target, String uid) async {
    switch (target) {
      case FeedTarget(:final pid):
        await toggle(
          pid,
          uid,
          key: bookmarks,
          subcol: bookmarks,
          kind: FeedKind.bookmark,
        );
        break;

      case CommentTarget(:final pid, :final cid):
        await subtoggle(
          pid,
          cid,
          uid,
          key: bookmarks,
          subcol: bookmarks,
          kind: FeedKind.bookmark,
        );
        break;
    }
  }

  @override
  String get path => posts;

  @override
  Feed from(AsMap map, String id) => Feed.from({...map, 'id': id});

  @override
  AsMap to(Feed model) => model.to();
}
