import 'package:get/get.dart';
import 'package:rxdart/streams.dart';
import 'package:semesta/public/extensions/list_extension.dart';
import 'package:semesta/public/functions/custom_toast.dart';
import 'package:semesta/public/helpers/cached_helper.dart';
import 'package:semesta/public/helpers/generic_helper.dart';
import 'package:semesta/app/controllers/action_controller.dart';
import 'package:semesta/public/mixins/repo_mixin.dart';
import 'package:semesta/app/controllers/post_controller.dart';
import 'package:semesta/app/models/feed.dart';
import 'package:semesta/app/models/reaction.dart';
import 'package:semesta/public/helpers/audit_view.dart';
import 'package:semesta/public/helpers/feed_view.dart';
import 'package:semesta/public/helpers/class_helper.dart';
import 'package:semesta/public/helpers/utils_helper.dart';
import 'package:semesta/public/utils/type_def.dart';

extension ActionControllerX on ActionController {
  Sync<StatusView> status$(String uid) => CombineLatestStream.combine3(
    urepo.sync$(uid),
    urepo.iFollow$(currentUid, uid),
    urepo.theyFollow$(currentUid, uid),
    (author, me, them) => StatusView(
      iFollow: me,
      author: author,
      theyFollow: them,
      authed: isCurrentUser(uid),
    ),
  ).shareReplay(maxSize: 1);

  Sync<RepostView> repost$(ActionTarget target, [String? uid]) {
    return prepo.syncDoc$(repostPath(target, uid ?? currentUid)).map((event) {
      final rxs = Reaction.from(event.data()!);
      final data = uCtrl.dataMapping[rxs.targetId]!;

      return RepostView(
        name: data.name,
        uid: rxs.targetId,
        authed: isCurrentUser(rxs.targetId),
      );
    });
  }

  Sync<StateView> state$(Feed item) => CombineLatestStream.combine2(
    status$(item.uid),
    actions$(item),
    (sts, rxs) => StateView(sts, rxs),
  ).shareReplay(maxSize: 1);

  Sync<ActionsView> actions$(Feed item) {
    final target = getTarget(item);
    return CombineLatestStream.combine4(
      prepo.sync$(feedPath(item)),
      prepo.favorited$(target, currentUid),
      prepo.bookmarked$(target, currentUid),
      prepo.reposted$(target, currentUid),
      (post, favorited, bookmarked, reposted) {
        final stats = post.stats;
        return ActionsView(
          feed: post,
          pid: post.id,
          target: target,
          reposted: reposted,
          favorited: favorited,
          bookmarked: bookmarked,
          views: stats.viewed,
          shares: stats.shared,
          reposts: stats.reposted,
          comments: stats.replied,
          favorites: stats.liked,
          bookmarks: stats.saved,
          quotes: stats.quoted,
        );
      },
    ).shareReplay(maxSize: 1);
  }

  Sync<FeedStateView> feed$(FeedView state) => CombineLatestStream.combine2(
    status$(state.feed.uid),
    actions$(state.feed),
    (status, rxs) => FeedStateView(
      actions: rxs,
      status: status.copy(actor: state.actor),
      content: state.copy(parent: state.parent, actor: state.actor),
    ),
  ).shareReplay(maxSize: 1);
}

extension PostControllerX on PostController {
  CachedState<FeedView> _state(String key) => stateFor(key);

  Wait<List<FeedView>> combinePosts(
    String uid, [
    QueryMode mode = QueryMode.normal,
  ]) async {
    final items = [
      ...await loadUserPosts(uid, mode),
      ...await loadUserReposts(uid, mode),
    ];

    return items.sortOrder;
  }

  Wait<List<FeedView>> combineFeeds(
    String uid, [
    QueryMode mode = QueryMode.normal,
  ]) async {
    final items = [
      ...await loadUserPosts(uid, mode),
      ...await loadUserReposts(uid, mode),
      ...await loadUserComments(uid, mode),
    ];

    return items.sortOrder;
  }

  AsWait get reloadPost async {
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

  AsWait get refreshPost async {
    await loadLatest(
      fetch: () => loadMoreForYou(QueryMode.refresh),
      apply: (items) => _state(getKey()).set(items.rankFeed(refreshSeed)),
      onError: () => _showError('Failed to refresh'),
    );
  }

  AsWait get refreshFollowing async {
    await loadLatest(
      fetch: () => loadMoreFollowing(QueryMode.refresh),
      apply: (items) => _state(getKey(screen: Screen.following)).merge(items),
      onError: () => _showError('Failed to refresh'),
    );
  }

  void _showError(String title) {
    final errorMessage = error.value ?? 'Unknown error';
    CustomToast.error(errorMessage, title: title);
  }
}
