import 'package:get/get.dart';
import 'package:rxdart/streams.dart';
import 'package:semesta/public/extensions/array_extension.dart';
import 'package:semesta/public/extensions/model_extension.dart';
import 'package:semesta/public/functions/custom_toast.dart';
import 'package:semesta/public/helpers/generic_helper.dart';
import 'package:semesta/app/controllers/action_controller.dart';
import 'package:semesta/public/mixins/post_mixin.dart';
import 'package:semesta/public/mixins/repository_mixin.dart';
import 'package:semesta/app/controllers/post_controller.dart';
import 'package:semesta/app/models/feed.dart';
import 'package:semesta/public/helpers/audit_view.dart';
import 'package:semesta/public/helpers/feed_view.dart';
import 'package:semesta/public/helpers/utils_helper.dart';
import 'package:semesta/public/utils/type_def.dart';

extension ActionControllerX on ActionController {
  /// Status stream, used to get the current status of a user (author, follow state, etc.) based on their UID.
  Sync<StatusView> status$(String uid) => CombineLatestStream.combine3(
    urepo.sync$(uid),
    urepo.follow$(currentUid, uid),
    urepo.follow$(currentUid, uid, false),
    (author, me, them) => StatusView(
      author,
      iFollow: me,
      theyFollow: them,
      authed: currentedUser(uid),
    ),
  ).shareReplay(maxSize: 1);

  /// Combine status and actions streams into a single state stream for a feed item,
  /// used to get the overall state of a feed item including the author's status and the user's interactions with it.
  Sync<StateView> state$(Feed item) => CombineLatestStream.combine2(
    status$(item.uid),
    actions$(item),
    (sts, rxs) => StateView(sts, rxs),
  ).shareReplay(maxSize: 1);

  /// Actions stream, used to get the current interaction states (favorited, bookmarked, reposted)
  /// for a feed item based on the target ID and user ID.
  Sync<ActionsView> actions$(Feed item) {
    final target = item.getTarget;
    return CombineLatestStream.combine4(
      prepo.sync$(item.toDoc),
      prepo.reaction$(target, currentUid),
      prepo.reaction$(target, currentUid, ActionType.save),
      prepo.reaction$(target, currentUid, ActionType.repost),
      (post, favorited, bookmarked, reposted) => ActionsView(
        post,
        target,
        pid: post.id,
        reposted: reposted,
        favorited: favorited,
        bookmarked: bookmarked,
      ),
    ).shareReplay(maxSize: 1);
  }

  /// Combine status and actions streams into a single state stream for a feed item,
  /// used to get the overall state of a feed item including the author's status and the user's interactions with it.
  Sync<FeedStateView> feed$(FeedView state) {
    final post = state.feed;
    return CombineLatestStream.combine2(
      status$(post.uid),
      actions$(post),
      (status, rxs) => FeedStateView(status, state, rxs),
    ).shareReplay(maxSize: 1);
  }
}

extension PostControllerX on PostController {
  Cacher<FeedView> _state(String key) => stateFor(key);

  /// A helper method to combine a user's posts and reposts into a single list of feed views, used for displaying a user's profile feed.
  Waits<FeedView> combinePosts(
    String uid, [
    QueryMode mode = QueryMode.normal,
  ]) async {
    return [
      ...await loadUserPosts(uid, mode),
      ...await loadUserReposts(uid, mode),
    ].sortOrder;
  }

  /// A helper method to combine a user's posts, reposts,
  /// and comments into a single list of feed views, used for displaying a user's activity feed.
  Waits<FeedView> combineFeeds(
    String uid, [
    QueryMode mode = QueryMode.normal,
  ]) async {
    return [
      ...await loadUserPosts(uid, mode),
      ...await loadUserReposts(uid, mode),
      ...await loadUserComments(uid, mode),
    ].sortOrder;
  }

  /// A helper method to refresh the user's posts and comments by clearing the current state
  /// and reloading the latest data, used for pull-to-refresh functionality on the profile and activity feeds.
  AsWait reloadPost() async {
    final pstate = _state(getKey(id: currentUid, screen: Screen.post));
    pstate.clear();

    final cstate = _state(getKey(id: currentUid, screen: Screen.comment));
    cstate.clear();

    await Future.wait([
      loadLatest(
        fetch: () => combinePosts(currentUid, QueryMode.refresh),
        apply: (items) => pstate.assignAll(items),
        onError: () => _showError('Failed to refresh'),
      ),

      loadLatest(
        fetch: () => combineFeeds(currentUid, QueryMode.refresh),
        apply: (items) => cstate.assignAll(items),
        onError: () => _showError('Failed to refresh'),
      ),
    ]);
  }

  /// A helper method to refresh the user's posts by clearing the current state
  /// and reloading the latest data, used for pull-to-refresh functionality on the profile feed.
  AsWait refreshPost() async {
    await loadLatest(
      fetch: () => loadMoreForYou(QueryMode.refresh),
      apply: (items) => _state(getKey()).set(items.rankFeed(refreshSeed)),
      onError: () => _showError('Failed to refresh'),
    );
  }

  /// A helper method to refresh the posts from followed users by clearing the current state
  /// and reloading the latest data, used for pull-to-refresh functionality on the home feed.
  AsWait refreshFollowing() async {
    await loadLatest(
      fetch: () => loadMoreFollowing(QueryMode.refresh),
      apply: (items) => _state(getKey(screen: Screen.following)).merge(items),
      onError: () => _showError('Failed to refresh'),
    );
  }

  void _showError(String title) {
    final message = error.value ?? 'Unknown error';
    CustomToast.error(message, title: title);
  }
}
