import 'package:semesta/core/models/reaction.dart';
import 'package:semesta/core/models/feed.dart';
import 'package:semesta/core/repositories/repository.dart';
import 'package:semesta/core/views/helper.dart';

mixin PostMixin on IRepository<Feed> {
  ///Read Data from DB
  Stream<bool> favorited$(ActionTarget target, String uid) {
    switch (target) {
      case FeedTarget(:final pid):
        return has$('$posts/$pid/$favorites/$uid');

      case CommentTarget(:final pid, :final cid):
        return has$('$posts/$pid/$comments/$cid/$favorites/$uid');
    }
  }

  Stream<bool> bookmarked$(ActionTarget target, String uid) {
    switch (target) {
      case FeedTarget(:final pid):
        return has$('$posts/$pid/$bookmarks/$uid');

      case CommentTarget(:final pid, :final cid):
        return has$('$posts/$pid/$comments/$cid/$bookmarks/$uid');
    }
  }

  Stream<bool> reposted$(ActionTarget target, String uid) {
    switch (target) {
      case FeedTarget(:final pid):
        return has$('$posts/$pid/$reposts/$uid');

      case CommentTarget(:final pid, :final cid):
        return has$('$posts/$pid/$comments/$cid/$reposts/$uid');
    }
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
        await toggle(pid, uid, subcol: reposts, key: reposts);
        break;

      case CommentTarget(:final pid, :final cid):
        await subtoggle(pid, cid, uid, subcol: reposts, key: reposts);
        break;
    }
  }

  Future<void> toggleBookmark(ActionTarget target, String uid) async {
    switch (target) {
      case FeedTarget(:final pid):
        await toggle(pid, uid, key: bookmarks, subcol: bookmarks);
        break;

      case CommentTarget(:final pid, :final cid):
        await subtoggle(pid, cid, uid, key: bookmarks, subcol: bookmarks);
        break;
    }
  }

  Future<List<Reaction>> loadReposts(String uid, {int limit = 30}) {
    return reactions(reposts, uid, limit: limit);
  }

  Future<List<Reaction>> loadBookmarks(String uid, {int limit = 30}) {
    return reactions(bookmarks, uid, limit: limit);
  }

  Future<List<Reaction>> loadFavorites(String uid, {int limit = 30}) {
    return reactions(favorites, uid, limit: limit);
  }

  Future<void> clearAllBookmarks(String uid) async {
    final query = await collection(users).doc(uid).collection(bookmarks).get();

    if (query.docs.isEmpty) return;

    final batch = db.batch();
    for (final doc in query.docs) {
      batch.delete(doc.reference);
    }

    await batch.commit();
  }
}
