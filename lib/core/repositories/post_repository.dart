import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:semesta/app/functions/logger.dart';
import 'package:semesta/core/mixins/post_mixin.dart';
import 'package:semesta/app/utils/type_def.dart';
import 'package:semesta/core/mixins/repo_mixin.dart';
import 'package:semesta/core/models/reaction.dart';
import 'package:semesta/core/models/feed.dart';
import 'package:semesta/core/repositories/repository.dart';
import 'package:semesta/core/repositories/user_repository.dart';

class PostRepository extends IRepository<Feed> with PostMixin {
  UserRepository get usr => UserRepository();

  Stream<List<Reaction>> followingIds(String uid, {int limit = 30}) {
    return liveReactions$(following, uid, limit: limit);
  }

  Future<void> insert(Feed model) async {
    assert(model.uid.isNotEmpty);

    try {
      await db.runTransaction((txs) async {
        // ─────────────────────────────────────────────
        // COMMENT
        // ─────────────────────────────────────────────
        if (model.type == Post.comment) {
          assert(model.pid.isNotEmpty);

          final parentRef = collection(path).doc(model.pid);
          final commentRef = parentRef.collection(comments).doc(); // 🔑 NEW ID

          final comment = model.copy(id: commentRef.id, pid: parentRef.id);
          txs.set(commentRef, comment.to());

          // increment comment counter on parent
          txs.update(parentRef, {'comments_count': FieldValue.increment(1)});

          return;
        }

        // ─────────────────────────────────────────────
        // QUOTE (standalone post with reference)
        // ─────────────────────────────────────────────
        if (model.type == Post.quote) {
          assert(model.pid.isNotEmpty);

          final quoteRef = collection(path).doc();
          final parentRef = collection(path).doc(model.pid);

          final quote = model.copy(id: quoteRef.id, pid: model.pid);
          txs.set(quoteRef, quote.to());

          // increment quote counter on parent post
          txs.update(parentRef, {'reposts_count': FieldValue.increment(1)});

          return;
        }

        // ─────────────────────────────────────────────
        // ORIGINAL POST
        // ─────────────────────────────────────────────
        final postRef = collection(path).doc();
        txs.set(postRef, model.copy(id: postRef.id).to());
      });
    } catch (e, s) {
      HandleLogger.error('Failed to create', message: e, stack: s);
      rethrow;
    }
  }

  Future<List<Feed>> loadComments(
    String uid, {
    String key = 'target_id',
    int limit = 20,
    QueryMode mode = QueryMode.normal,
  }) async {
    final query = subcollection(comments)
        .where(key, isEqualTo: uid)
        .orderBy('created_at', descending: true)
        .limit(mode == QueryMode.refresh ? 100 : limit);

    final snap = await query.get();
    return snap.docs.map((e) => Feed.from(e.data())).toList();
  }

  @override
  String get path => posts;

  @override
  Feed from(AsMap map, String id) => Feed.from({...map, 'id': id});

  @override
  AsMap to(Feed model) => model.to();
}
