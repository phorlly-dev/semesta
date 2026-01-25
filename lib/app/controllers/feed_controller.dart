import 'dart:async';
import 'package:semesta/public/extensions/list_extension.dart';
import 'package:semesta/public/helpers/generic_helper.dart';
import 'package:semesta/public/helpers/vendor_helper.dart';
import 'package:semesta/public/mixins/controller_mixin.dart';
import 'package:semesta/public/mixins/repo_mixin.dart';
import 'package:semesta/app/controllers/controller.dart';
import 'package:semesta/public/helpers/feed_view.dart';
import 'package:semesta/public/helpers/utils_helper.dart';

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
      ...mapToFeed(posts),
      ...mapToFeed(comments),
      ...mapFollowActions(reposts, actions: actions, type: FeedKind.reposted),
    ];

    if (merged.isEmpty) return const [];

    return merged;
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

    return mapFollowActions(
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

    return mapToFeed(posts, uid);
  }

  Future<List<FeedView>> loadUserReposts(
    String uid, [
    QueryMode mode = QueryMode.normal,
  ]) async {
    final actions = await prepo.getReposts(uid);
    final merged = await getSubcombined(actions, mode);

    return mapFollowActions(
      merged,
      uid: uid,
      actions: actions,
      type: FeedKind.reposted,
    );
  }

  Future<List<FeedView>> loadUserComments(
    String uid, [
    QueryMode mode = QueryMode.normal,
  ]) async {
    final posts = await prepo.getComments(uid, mode: mode);
    if (posts.isEmpty) return const [];

    return mapToFeed(posts, uid);
  }

  Future<List<FeedView>> loadUserMedia(
    String uid, [
    QueryMode mode = QueryMode.normal,
  ]) async {
    final merged = await getMerged(uid, mode);

    return mapFollowActions(
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

    return mapFollowActions(
      merged,
      uid: uid,
      actions: actions,
      type: FeedKind.liked,
    );
  }

  ///Load Bookmarks
  Future<List<FeedView>> loadUserBookmarks(
    String uid, [
    QueryMode mode = QueryMode.normal,
  ]) async {
    final actions = await prepo.getBookmarks(uid);
    final merged = await getSubcombined(actions, mode);

    return mapFollowActions(
      merged,
      uid: uid,
      actions: actions,
      type: FeedKind.saved,
    );
  }
}
