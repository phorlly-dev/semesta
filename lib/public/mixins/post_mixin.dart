import 'package:semesta/public/functions/logger.dart';
import 'package:semesta/public/utils/type_def.dart';
import 'package:semesta/public/helpers/generic_helper.dart';
import 'package:semesta/public/mixins/repo_mixin.dart';
import 'package:semesta/app/models/reaction.dart';
import 'package:semesta/app/models/feed.dart';
import 'package:semesta/app/repositories/repository.dart';
import 'package:semesta/public/helpers/class_helper.dart';

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

  Future<List<Reaction>> getBookmarks(String uid, [int limit = 30]) {
    return getReactions(
      limit: limit,
      col: bookmarks,
      conditions: {targetId: uid},
    );
  }

  Future<List<Reaction>> getFavorites(String uid, [int limit = 30]) {
    return getReactions(
      limit: limit,
      col: favorites,
      conditions: {targetId: uid},
    );
  }

  Future<List<Reaction>> getFollowing(String uid, [int limit = 30]) {
    return getReactions(
      limit: limit,
      col: following,
      conditions: {currentId: uid},
    );
  }

  Future<List<Reaction>> getReposts(dynamic value, [int limit = 30]) {
    return getReactions(
      col: reposts,
      limit: limit,
      conditions: {targetId: value},
    );
  }

  Future<List<Feed>> getComments(
    dynamic value, {
    int limit = 20,
    QueryMode mode = QueryMode.normal,
  }) => getInGrouped(conditions: {userId: value}, limit: limit, mode: mode);

  Future<List<Feed>> getReplies(
    String pid, {
    int limit = 20,
    QueryMode mode = QueryMode.normal,
  }) => getInGrouped(conditions: {postId: pid}, limit: limit, mode: mode);

  Future<List<Feed>> getPosts(
    dynamic value, {
    int limit = 20,
    String key = userId,
    QueryMode mode = QueryMode.normal,
    AsList visible = const [],
  }) {
    return prepo.queryAdvanced(
      mode: mode,
      limit: limit,
      conditions: {
        key: value,
        ...types,
        visibility: [public, following, ...visible],
      },
    );
  }

  Future<List<Feed>> getForYou({
    int limit = 20,
    QueryMode mode = QueryMode.normal,
  }) async {
    final posts = await prepo.queryAdvanced(
      mode: mode,
      conditions: {...types, visibility: public},
    );

    if (posts.isEmpty) return const [];

    return posts.toList();
  }

  Future<List<Reaction>> getForYouActions({
    int limit = 30,
    bool descending = true,
    String orderKey = made,
  }) {
    return subcollection(reposts)
        .limit(limit)
        .orderBy(orderKey, descending: descending)
        .get()
        .then((value) {
          return value.docs.map((doc) => Reaction.from(doc.data())).toList();
        })
        .catchError((error, stackTrace) {
          HandleLogger.error(
            'Failed to fetch reposts',
            message: error,
            stack: stackTrace,
          );

          return <Reaction>[];
        });
  }
}
