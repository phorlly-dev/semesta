import 'package:semesta/public/functions/logger.dart';
import 'package:semesta/public/helpers/generic_helper.dart';
import 'package:semesta/public/mixins/post_mixin.dart';
import 'package:semesta/public/utils/type_def.dart';
import 'package:semesta/app/models/feed.dart';
import 'package:semesta/app/repositories/repository.dart';
import 'package:semesta/public/helpers/class_helper.dart';
import 'package:semesta/public/helpers/utils_helper.dart';

class PostRepository extends IRepository<Feed> with PostMixin {
  Wait<void> insert(Feed model) async {
    assert(model.uid.isNotEmpty);

    try {
      await db.runTransaction((txs) async {
        switch (model.type) {
          // ─────────────────────────────────────────────
          // COMMENT
          // ─────────────────────────────────────────────
          case Create.reply:
            assert(model.pid.isNotEmpty);

            final parentRef = collection(path).doc(model.pid);
            final commentRef = parentRef.collection(comments).doc();

            final comment = model.copy(id: commentRef.id, pid: parentRef.id);
            txs
                .set(commentRef, comment.to())
                .update(parentRef, incrementStat(FeedKind.replied));
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
                .set(quoteRef, quote.to())
                .update(parentRef, incrementStat(FeedKind.quoted));
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

  Wait<void> toggleFavorite(ActionTarget target, String uid) async {
    switch (target) {
      case ParentTarget(:final pid):
        await toggle(pid, uid);
        break;

      case ChildTarget(:final pid, :final cid):
        await subtoggle(pid, cid, uid);
        break;
    }
  }

  Wait<void> toggleRepost(ActionTarget target, String uid) async {
    switch (target) {
      case ParentTarget(:final pid):
        await toggle(pid, uid, subcol: reposts, kind: FeedKind.reposted);
        break;

      case ChildTarget(:final pid, :final cid):
        await subtoggle(
          pid,
          cid,
          uid,
          subcol: reposts,
          kind: FeedKind.reposted,
        );
        break;
    }
  }

  Wait<void> toggleBookmark(ActionTarget target, String uid) async {
    switch (target) {
      case ParentTarget(:final pid):
        await toggle(pid, uid, subcol: bookmarks, kind: FeedKind.saved);
        break;

      case ChildTarget(:final pid, :final cid):
        await subtoggle(pid, cid, uid, subcol: bookmarks, kind: FeedKind.saved);
        break;
    }
  }

  Wait<void> destroyPost(Feed post, [String col = comments]) async {
    try {
      await db.runTransaction((txs) async {
        final ref = collection(path);
        final id = post.id;
        final pid = post.pid;

        switch (post.type) {
          case Create.quote:
            txs
                .delete(ref.doc(id))
                .update(ref.doc(pid), incrementStat(FeedKind.quoted, -1));
            break;

          case Create.reply:
            txs
                .delete(ref.doc(pid).collection(col).doc(id))
                .update(ref.doc(pid), incrementStat(FeedKind.replied, -1));
            break;

          default:
            txs.delete(ref.doc(id));
        }
      });
    } catch (e) {
      // Log error or handle appropriately
      HandleLogger.error('Failed to delete data: $e', message: e);
      rethrow; // or handle gracefully
    }
  }

  Wait<void> modifyPost(Feed post, AsMap data, [String col = comments]) async {
    try {
      await db.runTransaction((txs) async {
        final ref = collection(path);
        final id = post.id;
        final pid = post.pid;

        switch (post.type) {
          case Create.reply:
            txs.update(ref.doc(pid).collection(col).doc(id), data);
            break;

          default:
            txs.update(ref.doc(id), data);
        }
      });
    } catch (e) {
      // Log error or handle appropriately
      HandleLogger.error('Failed to update data: $e', message: e);
      rethrow; // or handle gracefully
    }
  }

  @override
  String get path => posts;

  @override
  Feed from(AsMap map, String id) => Feed.from({...map, 'id': id});

  @override
  AsMap to(Feed model) => model.to();
}
