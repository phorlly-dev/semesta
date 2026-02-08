import 'package:semesta/public/extensions/model_extension.dart';
import 'package:semesta/public/functions/func_helper.dart';
import 'package:semesta/public/helpers/generic_helper.dart';
import 'package:semesta/public/mixins/repo_mixin.dart';
import 'package:semesta/app/models/reaction.dart';
import 'package:semesta/app/models/feed.dart';
import 'package:semesta/app/repositories/repository.dart';
import 'package:semesta/public/helpers/class_helper.dart';
import 'package:semesta/public/utils/type_def.dart';

enum ActionType { like, save, repost }

mixin PostMixin on IRepository<Feed> {
  ///Read Data from DB
  Sync<bool> reaction$(
    ActionTarget target,
    String uid, [
    ActionType type = ActionType.like,
  ]) => switch (type) {
    ActionType.like => has$(target.toPath(uid)),
    ActionType.save => has$(target.toPath(uid, ccol: bookmarks)),
    ActionType.repost => has$(target.toPath(uid, ccol: reposts)),
  };

  Waits<Reaction> getActions(
    dynamic value, {
    int limit = 30,
    ActionType type = ActionType.like,
  }) => switch (type) {
    ActionType.like => getReactions(
      {targetId: value},
      limit: limit,
      col: favorites,
    ),
    ActionType.save => getReactions(
      {targetId: value},
      limit: limit,
      col: bookmarks,
    ),
    ActionType.repost => getReactions(
      {targetId: value},
      col: reposts,
      limit: limit,
    ),
  };

  Waits<Feed> getComments(
    dynamic value, {
    int limit = 20,
    QueryMode mode = QueryMode.normal,
  }) => getInGrouped({userId: value}, limit: limit, mode: mode);

  Waits<Feed> getReplies(
    String pid, {
    int limit = 20,
    QueryMode mode = QueryMode.normal,
  }) => getInGrouped({postId: pid}, limit: limit, mode: mode);

  Waits<Feed> getPosts(
    dynamic value, {
    int limit = 20,
    String key = userId,
    QueryMode mode = QueryMode.normal,
  }) => prepo.query({key: value, ...types}, mode: mode, limit: limit);

  Waits<Feed> getForYou({
    int limit = 20,
    QueryMode mode = QueryMode.normal,
  }) async {
    final posts = await prepo.query({...types, visibility: public}, mode: mode);
    return posts.isNotEmpty ? posts : const [];
  }

  Waits<Reaction> getForYouActions({
    int limit = 30,
    bool descending = true,
    String orderKey = made,
    String col = reposts,
  }) async {
    final res = await subcollection(
      col,
    ).limit(limit).orderBy(orderKey, descending: descending).get();

    return res.docs.isNotEmpty ? getList(res, Reaction.from) : const [];
  }
}
