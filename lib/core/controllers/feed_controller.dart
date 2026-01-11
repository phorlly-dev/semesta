import 'dart:async';
import 'package:semesta/app/extensions/list_extension.dart';
import 'package:semesta/core/views/generic_helper.dart';
import 'package:semesta/core/mixins/controller_mixin.dart';
import 'package:semesta/core/mixins/repo_mixin.dart';
import 'package:semesta/core/controllers/controller.dart';
import 'package:semesta/core/views/feed_view.dart';
import 'package:semesta/core/views/utils_helper.dart';

abstract class IFeedController extends IController<FeedView>
    with ControllerMixin {
  Future<List<FeedView>> loadMoreForYou([
    QueryMode mode = QueryMode.normal,
  ]) async {
    final actions = await prepo.getForYouActions();
    final reposts = await getSubcombined(actions, mode);

    final posts = await prepo.getForYou(mode: mode);
    for (final p in posts) {
      listenToPost(p.id);
    }

    final comments = await prepo.subindex(mode: mode);
    for (final c in comments) {
      listenTComment(c.id, c.pid);
    }

    final merged = [
      ...mapToFeeds(posts),
      ...mapToFeed(reposts, actions: actions),
    ];

    if (merged.isEmpty) return const [];

    return merged.toList();
  }

  Future<List<FeedView>> loadMoreFollowing([
    QueryMode mode = QueryMode.normal,
  ]) async {
    final actions = await prepo.getFollowing(currentUid);
    final ids = getKeys(actions, (value) => value.targetId);
    final ractions = await prepo.getReposts(ids);

    final merged = [
      ...await getCombined(actions, mode),
      ...await getSubcombined(ractions, mode),
    ];

    if (merged.isEmpty) return const [];

    return mapToFeed(
      merged,
      actions: ractions,
      type: FeedKind.following,
    ).sortOrder;
  }

  Future<List<FeedView>> loadUserPosts(
    String uid, [
    QueryMode mode = QueryMode.normal,
  ]) async {
    final posts = await prepo.getPosts(uid, mode: mode, visible: ['mentioned']);
    if (posts.isEmpty) return const [];

    return mapToFeeds(posts, uid);
  }

  Future<List<FeedView>> loadUserReposts(
    String uid, [
    QueryMode mode = QueryMode.normal,
  ]) async {
    final actions = await prepo.getReposts(uid);
    final merged = await getSubcombined(actions, mode);

    return mapToFeed(merged, actions: actions, uid: uid);
  }

  Future<List<FeedView>> loadUserComments(
    String uid, [
    QueryMode mode = QueryMode.normal,
  ]) async {
    final posts = await prepo.getComments(uid, mode: mode);
    if (posts.isEmpty) return const [];

    return mapToFeed(posts, type: FeedKind.comment, uid: uid);
  }

  Future<List<FeedView>> loadUserMedia(
    String uid, [
    QueryMode mode = QueryMode.normal,
  ]) async {
    final merged = await getMerged(uid, mode);

    return mapToFeed(
      uid: uid,
      type: FeedKind.media,
      merged.where((m) => m.media.isNotEmpty).toList(),
    );
  }

  //Load Favorites
  Future<List<FeedView>> loadUserFavorites(
    String uid, [
    QueryMode mode = QueryMode.normal,
  ]) async {
    final actions = await prepo.getFavorites(uid);
    final merged = await getSubcombined(actions, mode);

    return mapToFeed(merged, actions: actions, uid: uid);
  }

  ///Load Bookmarks
  Future<List<FeedView>> loadUserBookmarks(
    String uid, [
    QueryMode mode = QueryMode.normal,
  ]) async {
    final actions = await prepo.getBookmarks(uid);
    final merged = await getSubcombined(actions, mode);

    return mapToFeed(merged, actions: actions, uid: uid);
  }
}
