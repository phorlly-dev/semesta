import 'package:get/get.dart';
import 'package:rxdart/streams.dart';
import 'package:semesta/public/extensions/list_extension.dart';
import 'package:semesta/public/extensions/model_extension.dart';
import 'package:semesta/public/functions/custom_toast.dart';
import 'package:semesta/public/helpers/generic_helper.dart';
import 'package:semesta/app/controllers/action_controller.dart';
import 'package:semesta/public/mixins/post_mixin.dart';
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
    urepo.follow$(currentUid, uid),
    urepo.follow$(currentUid, uid, false),
    (author, me, them) {
      return StatusView(
        author,
        iFollow: me,
        theyFollow: them,
        authed: currentedUser(uid),
      );
    },
  ).shareReplay(maxSize: 1);

  Sync<RepostView> repost$(ActionTarget target, [String? uid]) => prepo
      .syncDoc$(target.toPath(uid ?? currentUid, ccol: reposts))
      .map((event) {
        final state = Reaction.from(event.data()!);
        final data = uCtrl.dataMapping[state.targetId]!;

        return RepostView(
          state.targetId,
          data.name,
          currentedUser(state.targetId),
        );
      });

  Sync<StateView> state$(Feed item) => CombineLatestStream.combine2(
    status$(item.uid),
    actions$(item),
    (sts, rxs) => StateView(sts, rxs),
  ).shareReplay(maxSize: 1);

  Sync<ActionsView> actions$(Feed item) {
    final target = item.getTarget;
    return CombineLatestStream.combine4(
      prepo.sync$(item.toDoc),
      prepo.reaction$(target, currentUid),
      prepo.reaction$(target, currentUid, ActionType.save),
      prepo.reaction$(target, currentUid, ActionType.repost),
      (post, favorited, bookmarked, reposted) => ActionsView(
        post,
        post.stats,
        target,
        pid: post.id,
        reposted: reposted,
        favorited: favorited,
        bookmarked: bookmarked,
      ),
    ).shareReplay(maxSize: 1);
  }

  Sync<FeedStateView> feed$(FeedView state) {
    final post = state.feed;
    final parent = pCtrl.dataMapping[post.pid];
    final actor = uCtrl.dataMapping[parent?.uid ?? post.uid];
    return CombineLatestStream.combine2(
      status$(post.uid),
      actions$(post),
      (status, rxs) => FeedStateView(
        status.copy(actor: state.actor ?? actor),
        state.copy(parent: state.parent ?? parent, actor: state.actor ?? actor),
        rxs,
      ),
    ).shareReplay(maxSize: 1);
  }
}

extension PostControllerX on PostController {
  Cacher<FeedView> _state(String key) => stateFor(key);

  Waits<FeedView> combinePosts(
    String uid, [
    QueryMode mode = QueryMode.normal,
  ]) async {
    final items = [
      ...await loadUserPosts(uid, mode),
      ...await loadUserReposts(uid, mode),
    ];

    return items.sortOrder;
  }

  Waits<FeedView> combineFeeds(
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

  AsWait refreshPost() async {
    await loadLatest(
      fetch: () => loadMoreForYou(QueryMode.refresh),
      apply: (items) => _state(getKey()).set(items.rankFeed(refreshSeed)),
      onError: () => _showError('Failed to refresh'),
    );
  }

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
