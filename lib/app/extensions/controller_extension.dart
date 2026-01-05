import 'package:rxdart/streams.dart';
import 'package:semesta/app/extensions/list_extension.dart';
import 'package:semesta/app/functions/custom_toast.dart';
import 'package:semesta/core/controllers/action_controller.dart';
import 'package:semesta/core/mixins/repo_mixin.dart';
import 'package:semesta/core/controllers/post_controller.dart';
import 'package:semesta/core/models/feed.dart';
import 'package:semesta/core/models/reaction.dart';
import 'package:semesta/core/views/audit_view.dart';
import 'package:semesta/core/views/feed_view.dart';
import 'package:semesta/core/views/helper.dart';

bool isComment(Feed f) => f.type == Post.comment && f.pid.isNotEmpty;
String feedPath(Feed f) {
  if (isComment(f)) {
    return '${f.pid}/replies/${f.id}';
  }

  return f.id;
}

extension ActionControllerX on ActionController {
  Stream<StatusView> statusStream$(String uid) {
    final ru = repo.usr;
    return CombineLatestStream.combine3(
      ru.stream$(uid),
      ru.iFollow$(currentUid, uid),
      ru.theyFollow$(currentUid, uid),
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

  Stream<RepostView> repostStream$(String pid, String uid) {
    return repo.liveStream('$pid/reposts/$uid').map((event) {
      if (event.data() == null) {
        throw StateError('Event data is null');
      }

      final rxs = Reaction.from(event.data()!);
      final data = uCtrl.dataMapping[rxs.targetId];

      if (data == null) {
        throw StateError('Data mapping is null');
      }

      return RepostView(
        reposted: true,
        name: data.name,
        uid: rxs.targetId,
        authed: isCurrentUser(rxs.targetId),
      );
    });
  }

  Stream<ActionsView> actionsStream$(Feed item) {
    final target = isComment(item)
        ? CommentTarget(item.pid, item.id)
        : FeedTarget(item.id);

    return CombineLatestStream.combine4(
      repo.stream$(feedPath(item)),
      repo.favorited$(target, currentUid),
      repo.bookmarked$(target, currentUid),
      repo.reposted$(target, currentUid),
      (post, favorited, bookmarked, reposted) {
        return ActionsView(
          pid: post.id,
          favorited: favorited,
          bookmarked: bookmarked,
          reposted: reposted,
          target: target,
          favorites: post.favoritesCount,
          bookmarks: post.bookmarksCount,
          reposts: post.repostsCount,
          views: post.viewsCount,
          comments: post.commentsCount,
          shares: post.sharesCount,
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
        final actor = uCtrl.dataMapping[post.uid];
        final parent = post.pid.isNotEmpty ? pCtrl.dataMapping[post.pid] : null;

        return FeedStateView(
          status: status.copy(actor: actor),
          content: state.copy(parent: parent),
          actions: rxs,
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

  Future<void> refreshPost() async {
    await loadLatest(
      fetch: () => loadMoreForYou(QueryMode.refresh),
      apply: (items) {
        final ranked = items.rankFeed(refreshSeed);
        stateFor('home:all').set(ranked);
      },
      onError: () => _showError('Failed to refresh'),
    );
  }

  Future<void> refreshFollowing() async {
    final ids = followingIds.toList();
    if (ids.isNotEmpty) {
      await loadLatest(
        fetch: () => loadMoreFollowing(ids, QueryMode.refresh),
        apply: (items) {
          final sorted = items.sortOrder;
          stateFor('home:following').merge(sorted);
        },
        onError: () => _showError('Failed to refresh'),
      );
    }
  }

  void _showError(String title) {
    final errorMessage = error.value ?? 'Unknown error';
    CustomToast.error(errorMessage, title: title);
  }
}
