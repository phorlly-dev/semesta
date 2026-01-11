import 'package:rxdart/streams.dart';
import 'package:semesta/app/extensions/list_extension.dart';
import 'package:semesta/app/functions/custom_toast.dart';
import 'package:semesta/core/views/generic_helper.dart';
import 'package:semesta/core/controllers/action_controller.dart';
import 'package:semesta/core/mixins/repo_mixin.dart';
import 'package:semesta/core/controllers/post_controller.dart';
import 'package:semesta/core/models/feed.dart';
import 'package:semesta/core/models/reaction.dart';
import 'package:semesta/core/views/audit_view.dart';
import 'package:semesta/core/views/feed_view.dart';
import 'package:semesta/core/views/class_helper.dart';
import 'package:semesta/core/views/utils_helper.dart';

extension ActionControllerX on ActionController {
  Stream<StatusView> statusStream$(String uid) {
    return CombineLatestStream.combine3(
      urepo.stream$(uid),
      urepo.iFollow$(currentUid, uid),
      urepo.theyFollow$(currentUid, uid),
      (author, me, them) {
        return StatusView(
          authed: isCurrentUser(uid),
          iFollow: me,
          theyFollow: them,
          author: author,
        );
      },
    ).shareReplay(maxSize: 1);
  }

  Stream<RepostView> repostStream$(ActionTarget target, String uid) {
    return prepo.liveStream(repostPath(target, uid)).map((event) {
      final rxs = Reaction.from(event.data()!);
      final data = uCtrl.dataMapping[rxs.targetId]!;

      return RepostView(
        name: data.name,
        uid: rxs.targetId,
        authed: isCurrentUser(rxs.targetId),
      );
    });
  }

  Stream<CommentView> commentSteam$(Feed item) {
    return CombineLatestStream.combine2(
      statusStream$(item.uid),
      actionsStream$(item),
      (sts, rxs) => CommentView(feed: rxs.feed, status: sts, actions: rxs),
    ).shareReplay(maxSize: 1);
  }

  Stream<ActionsView> actionsStream$(Feed item) {
    final target = isComment(item)
        ? CommentTarget(item.pid, item.id)
        : FeedTarget(item.id);
    return CombineLatestStream.combine4(
      prepo.stream$(feedPath(item)),
      prepo.favorited$(target, currentUid),
      prepo.bookmarked$(target, currentUid),
      prepo.reposted$(target, currentUid),
      (post, favorited, bookmarked, reposted) {
        return ActionsView(
          feed: post,
          pid: post.id,
          target: target,
          reposted: reposted,
          favorited: favorited,
          bookmarked: bookmarked,
          views: post.viewsCount,
          shares: post.sharesCount,
          reposts: post.repostsCount,
          comments: post.commentsCount,
          favorites: post.favoritesCount,
          bookmarks: post.bookmarksCount,
        );
      },
    ).shareReplay(maxSize: 1);
  }

  Stream<FeedStateView> feedStream$(FeedView state) {
    final post = state.feed;
    return CombineLatestStream.combine2(
      statusStream$(post.uid),
      actionsStream$(post),
      (status, rxs) {
        final parent = pCtrl.dataMapping[post.pid];
        final actor = uCtrl.dataMapping[parent?.uid ?? ''];

        return FeedStateView(
          actions: rxs,
          status: status,
          content: state.copy(parent: parent, actor: actor),
        );
      },
    ).shareReplay(maxSize: 1);
  }
}

extension PostControllerX on PostController {
  Future<List<FeedView>> combinePosts(
    String uid, [
    QueryMode mode = QueryMode.normal,
  ]) async {
    final posts = await loadUserPosts(uid, mode);
    final reposts = await loadUserReposts(uid, mode);
    final items = [...posts, ...reposts];

    return items.sortOrder;
  }

  Future<List<FeedView>> combineFeeds(
    String uid, [
    QueryMode mode = QueryMode.normal,
  ]) async {
    final posts = await loadUserPosts(uid, mode);
    final reposts = await loadUserReposts(uid, mode);
    final comments = await loadUserComments(uid, mode);
    final items = [...posts, ...reposts, ...comments];

    return items.sortOrder;
  }

  Future<void> refreshPost() async {
    await loadLatest(
      fetch: () => loadMoreForYou(QueryMode.refresh),
      apply: (items) {
        final ranked = items.rankFeed(refreshSeed);
        stateFor(getKey()).set(ranked);
      },
      onError: () => _showError('Failed to refresh'),
    );
  }

  Future<void> refreshFollowing() async {
    await loadLatest(
      fetch: () => loadMoreFollowing(QueryMode.refresh),
      apply: (items) {
        stateFor(getKey(screen: Screen.following)).merge(items);
      },
      onError: () => _showError('Failed to refresh'),
    );
  }

  void _showError(String title) {
    final errorMessage = error.value ?? 'Unknown error';
    CustomToast.error(errorMessage, title: title);
  }
}
