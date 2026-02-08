import 'package:semesta/public/extensions/list_extension.dart';
import 'package:semesta/public/extensions/model_extension.dart';
import 'package:semesta/public/helpers/generic_helper.dart';
import 'package:semesta/public/helpers/vendor_helper.dart';
import 'package:semesta/public/mixins/controller_mixin.dart';
import 'package:semesta/public/mixins/helper_mixin.dart';
import 'package:semesta/public/mixins/post_mixin.dart';
import 'package:semesta/public/mixins/repo_mixin.dart';
import 'package:semesta/app/controllers/controller.dart';
import 'package:semesta/public/helpers/feed_view.dart';
import 'package:semesta/public/utils/type_def.dart';

abstract class IFeedController extends IController<FeedView>
    with ControllerMixin, HelperMixin {
  Waits<FeedView> loadMoreForYou([QueryMode mode = QueryMode.normal]) async {
    final actions = await prepo.getForYouActions();
    final reposts = await getSubcombined(actions, mode);

    final posts = await prepo.getForYou(mode: mode);
    for (final p in posts) {
      listenToPost(p);
    }

    final comments = await prepo.subindex(mode: mode);
    for (final c in comments) {
      listenToPost(c);
    }

    final merged = [
      ...mapToFeed(posts),
      ...mapToFeed(comments),
      ...mapFollowActions(reposts, actions: actions, type: FeedKind.reposted),
    ];

    return merged.isNotEmpty ? merged : const [];
  }

  Waits<FeedView> loadMoreFollowing([QueryMode mode = QueryMode.normal]) async {
    final actions = await urepo.getFollowing(currentUid);
    final ids = getKeys(actions, (value) => value.targetId);
    final ractions = await prepo.getActions(ids, type: ActionType.repost);

    final merged = [
      ...await getCombined(actions, mode),
      ...await getSubcombined(ractions, mode),
    ];

    return merged.isNotEmpty
        ? mapFollowActions(
            merged,
            actions: ractions,
            type: FeedKind.following,
          ).sortOrder
        : const [];
  }

  Waits<FeedView> loadUserPosts(
    String uid, [
    QueryMode mode = QueryMode.normal,
  ]) => prepo.getPosts(uid, mode: mode).then((value) {
    for (final p in value) {
      listenToPost(p);
    }

    return value.isNotEmpty ? mapToFeed(value, uid) : const [];
  });

  Waits<FeedView> loadUserReposts(
    String uid, [
    QueryMode mode = QueryMode.normal,
  ]) async {
    final actions = await prepo.getActions(uid, type: ActionType.repost);
    final merged = await getSubcombined(actions, mode);

    return merged.isNotEmpty
        ? mapFollowActions(
            merged,
            uid: uid,
            actions: actions,
            type: FeedKind.reposted,
          )
        : const [];
  }

  Waits<FeedView> loadUserComments(
    String uid, [
    QueryMode mode = QueryMode.normal,
  ]) => prepo.getComments(uid, mode: mode).then((value) {
    for (final c in value) {
      listenToPost(c);
    }

    return value.isNotEmpty
        ? mapToFeed(value.where((v) => v.pid.isNotEmpty).toList(), uid)
        : const [];
  });

  Waits<FeedView> loadPostComments(
    String pid, [
    QueryMode mode = QueryMode.normal,
  ]) => prepo.getReplies(pid, mode: mode).then((value) {
    return value.isNotEmpty
        ? mapToFeed(value.where((v) => v.pid.isNotEmpty).toList())
        : const [];
  });

  Waits<FeedView> loadUserMedia(
    String uid, [
    QueryMode mode = QueryMode.normal,
  ]) => getMerged(uid, mode).then(
    (value) => value.isNotEmpty
        ? mapFollowActions(
            uid: uid,
            type: FeedKind.media,
            value.where((f) => f.media.isNotEmpty).toList(),
          )
        : const [],
  );

  Waits<FeedView> loadReelsMedia([QueryMode mode = QueryMode.normal]) async {
    final merged = [
      ...await prepo.getForYou(mode: mode),
      ...await prepo.subindex(mode: mode),
    ];

    return merged.isNotEmpty
        ? mapToFeed(
            merged.where((e) {
              return e.media.isNotEmpty && e.media[0].mp4;
            }).toList(),
          )
        : const [];
  }

  //Load Favorites
  Waits<FeedView> loadUserFavorites(
    String uid, [
    QueryMode mode = QueryMode.normal,
  ]) async {
    final actions = await prepo.getActions(uid);
    final merged = await getSubcombined(actions, mode);

    return merged.isNotEmpty
        ? mapFollowActions(
            merged,
            uid: uid,
            actions: actions,
            type: FeedKind.liked,
          )
        : const [];
  }

  ///Load Bookmarks
  Waits<FeedView> loadUserBookmarks(
    String uid, [
    QueryMode mode = QueryMode.normal,
  ]) async {
    final actions = await prepo.getActions(uid, type: ActionType.save);
    final merged = await getSubcombined(actions, mode);

    return merged.isNotEmpty
        ? mapFollowActions(
            merged,
            uid: uid,
            actions: actions,
            type: FeedKind.saved,
          )
        : const [];
  }
}
