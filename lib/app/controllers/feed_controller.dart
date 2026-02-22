import 'package:semesta/app/models/feed.dart';
import 'package:semesta/app/models/hashtag.dart';
import 'package:semesta/public/extensions/array_extension.dart';
import 'package:semesta/public/extensions/model_extension.dart';
import 'package:semesta/public/helpers/audit_view.dart';
import 'package:semesta/public/helpers/class_helper.dart';
import 'package:semesta/public/helpers/generic_helper.dart';
import 'package:semesta/public/mixins/controller_mixin.dart';
import 'package:semesta/public/mixins/post_mixin.dart';
import 'package:semesta/public/mixins/repository_mixin.dart';
import 'package:semesta/app/controllers/controller.dart';
import 'package:semesta/public/helpers/feed_view.dart';
import 'package:semesta/public/utils/type_def.dart';

abstract class IFeedController extends IController<FeedView>
    with ControllerMixin {
  Waits<FeedView> loadMoreForYou([QueryMode mode = QueryMode.normal]) async {
    final actions = await prepo.getForYouActions();
    final reposts = await getSubcombined(actions, mode);
    return [
      ...(await prepo.getForYou(mode: mode)).fromFeeds(),
      ...(await prepo.subindex(mode: mode)).fromFeeds(),
      ...reposts.fromActions(actions: actions, type: FeedKind.reposts),
    ];
  }

  Waits<FeedView> loadMoreFollowing([QueryMode mode = QueryMode.normal]) async {
    final actions = await urepo.getFollows(currentUid);
    final keys = actions.toKeys((value) => value.tid);
    final ractions = await prepo.getActions(keys, type: ActionType.repost);
    return [
      ...await getCombined(actions, mode),
      ...await getSubcombined(ractions, mode),
    ].fromActions(actions: ractions, type: FeedKind.following);
  }

  Waits<FeedView> loadUserPosts(
    String uid, [
    QueryMode mode = QueryMode.normal,
  ]) => prepo.getPosts(uid, mode: mode).then((value) => value.fromFeeds(uid));

  Waits<FeedView> loadUserReposts(
    String uid, [
    QueryMode mode = QueryMode.normal,
  ]) async {
    final actions = await prepo.getActions(uid, type: ActionType.repost);
    final merged = await getSubcombined(actions, mode);
    return merged.fromActions(
      uid: uid,
      actions: actions,
      type: FeedKind.reposts,
    );
  }

  Waits<FeedView> loadUserComments(
    String uid, [
    QueryMode mode = QueryMode.normal,
  ]) => prepo.getComments(uid, mode: mode).then((value) {
    return value.where((v) => v.pid.isNotEmpty).toList().fromFeeds(uid);
  });

  Waits<FeedView> loadPostComments(
    String pid, [
    QueryMode mode = QueryMode.normal,
  ]) => prepo.getReplies(pid, mode: mode).then((value) {
    return value.where((v) => v.pid.isNotEmpty).toList().fromFeeds();
  });

  Waits<FeedView> loadUserMedia(
    String uid, [
    QueryMode mode = QueryMode.normal,
  ]) => getMerged(uid, mode).then((value) {
    return value
        .where((f) => f.media.isNotEmpty)
        .toList()
        .fromActions(uid: uid, type: FeedKind.media);
  });

  Waits<FeedView> loadReelsMedia([QueryMode mode = QueryMode.normal]) async {
    return [
      ...await prepo.getForYou(mode: mode),
      ...await prepo.subindex(mode: mode),
    ].where((e) => e.media.isNotEmpty && e.media[0].mp4).toList().fromFeeds();
  }

  //Load Favorites
  Waits<FeedView> loadUserFavorites(
    String uid, [
    QueryMode mode = QueryMode.normal,
  ]) async {
    final actions = await prepo.getActions(uid);
    final merged = await getSubcombined(actions, mode);
    return merged.fromActions(uid: uid, actions: actions, type: FeedKind.likes);
  }

  ///Load Bookmarks
  Waits<FeedView> loadUserBookmarks(
    String uid, [
    QueryMode mode = QueryMode.normal,
  ]) async {
    final actions = await prepo.getActions(uid, type: ActionType.save);
    final merged = await getSubcombined(actions, mode);
    return merged.fromActions(uid: uid, actions: actions, type: FeedKind.saves);
  }

  ///Load Hashtags
  Waits<Hashtag> loadHashtags(String input) => prepo.fetchHashtags(input);

  ///Load User Repost
  Wait<RepostView?> loadRepost(ActionTarget target, [String? uid]) {
    return prepo.fetchRepost(target, uid ?? currentUid);
  }

  ///Load User Quote
  Wait<ReferenceView?> loadReference(Feed content, [bool primary = true]) {
    return prepo.fetchReference(content, primary);
  }

  ///Load Post
  Wait<Feed?> loadFeed(String pid) => prepo.show(pid);
}
