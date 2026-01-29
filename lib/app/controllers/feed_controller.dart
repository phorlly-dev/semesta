import 'package:semesta/app/models/media.dart';
import 'package:semesta/public/extensions/list_extension.dart';
import 'package:semesta/public/helpers/generic_helper.dart';
import 'package:semesta/public/helpers/vendor_helper.dart';
import 'package:semesta/public/mixins/controller_mixin.dart';
import 'package:semesta/public/mixins/helper_mixin.dart';
import 'package:semesta/public/mixins/repo_mixin.dart';
import 'package:semesta/app/controllers/controller.dart';
import 'package:semesta/public/helpers/feed_view.dart';
import 'package:semesta/public/helpers/utils_helper.dart';
import 'package:semesta/public/utils/type_def.dart';

abstract class IFeedController extends IController<FeedView>
    with ControllerMixin, HelperMixin {
  Wait<List<FeedView>> loadMoreForYou([
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
      listenToComment(c.id, c.pid);
    }

    final merged = [
      ...mapToFeed(posts),
      ...mapToFeed(comments),
      ...mapFollowActions(reposts, actions: actions, type: FeedKind.reposted),
    ];

    if (merged.isEmpty) return const [];

    return merged;
  }

  Wait<List<FeedView>> loadMoreFollowing([
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

  Wait<List<FeedView>> loadUserPosts(
    String uid, [
    QueryMode mode = QueryMode.normal,
  ]) => prepo.getPosts(uid, mode: mode).then((value) {
    for (final p in value) {
      listenToPost(p.id);
    }

    return mapToFeed(value, uid);
  });

  Wait<List<FeedView>> loadUserReposts(
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

  Wait<List<FeedView>> loadUserComments(
    String uid, [
    QueryMode mode = QueryMode.normal,
  ]) => prepo.getComments(uid, mode: mode).then((value) {
    for (final c in value) {
      listenToComment(c.id, c.pid);
    }

    return mapToFeed(value.where((v) => v.pid.isNotEmpty).toList(), uid);
  });

  Wait<List<FeedView>> loadPostComments(
    String pid, [
    QueryMode mode = QueryMode.normal,
  ]) => prepo.getReplies(pid, mode: mode).then((value) {
    return mapToFeed(value.where((v) => v.pid.isNotEmpty).toList());
  });

  Wait<List<FeedView>> loadUserMedia(
    String uid, [
    QueryMode mode = QueryMode.normal,
  ]) => getMerged(uid, mode).then(
    (value) => mapFollowActions(
      uid: uid,
      type: FeedKind.media,
      value.where((m) => m.media.isNotEmpty).toList(),
    ),
  );

  Wait<List<FeedView>> loadReelsMedia([
    QueryMode mode = QueryMode.normal,
  ]) async {
    final merged = [
      ...await prepo.getForYou(mode: mode),
      ...await prepo.subindex(mode: mode),
    ];

    return mapToFeed(
      merged.where((e) {
        return e.media.isNotEmpty && e.media[0].type == MediaType.video;
      }).toList(),
    );
  }

  //Load Favorites
  Wait<List<FeedView>> loadUserFavorites(
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
  Wait<List<FeedView>> loadUserBookmarks(
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
