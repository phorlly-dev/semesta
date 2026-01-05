import 'dart:async';
import 'package:get/get.dart';
import 'package:semesta/app/extensions/list_extension.dart';
import 'package:semesta/app/functions/format.dart';
import 'package:semesta/app/utils/type_def.dart';
import 'package:semesta/core/mixins/repo_mixin.dart';
import 'package:semesta/app/utils/cached_helper.dart';
import 'package:semesta/core/controllers/controller.dart';
import 'package:semesta/core/controllers/user_controller.dart';
import 'package:semesta/core/models/feed.dart';
import 'package:semesta/core/models/author.dart';
import 'package:semesta/core/repositories/post_repository.dart';
import 'package:semesta/core/views/audit_view.dart';
import 'package:semesta/core/views/feed_view.dart';
import 'package:semesta/core/views/helper.dart';

abstract class IFeedController extends IController<FeedView> {
  StreamSubscription? _postSub, _userSub;
  final repo = PostRepository();
  final uCtrl = Get.put(UserController());

  //Public
  final followingIds = <String>[];
  final dataMapping = <String, Feed>{}.obs;

  final Map<String, CachedState<FeedView>> _states = {};
  CachedState<FeedView> stateFor(String key) {
    return _states.putIfAbsent(key, () => CachedState<FeedView>());
  }

  final Map<String, TabMeta> _meta = {};
  TabMeta metaFor(String key) => _meta.putIfAbsent(key, () => TabMeta());

  void addRepostToTabs(String key, String pid) {
    final state = stateFor(key);

    final rowId = buildRowId(pid: pid, kind: FeedKind.repost, uid: currentUid);
    if (state.any((e) => e.currentId == rowId)) return;

    final post = dataMapping[pid];
    if (post == null) return;

    state.insert(
      0,
      FeedView(
        rid: rowId,
        uid: currentUid,
        feed: post,
        kind: FeedKind.repost,
        created: now,
      ),
    );

    state.refresh();
  }

  void clearFor(String key, String rid) {
    final state = stateFor(key);

    state.removeWhere((s) => s.currentId == rid);
    state.refresh(); // notify RxList
  }

  void invalidate(String key) {
    stateFor(key).clear(); // same RxList instance => Obx rebuild
    metaFor(key).dirty = true; // next switch triggers refill
  }

  //User cached
  String get currentUid => uCtrl.currentUid.value;
  bool isCurrentUser(String uid) {
    return currentUid.isNotEmpty && currentUid == uid;
  }

  Author get currentUser {
    final currentUser = uCtrl.currentUser.value;
    if (currentUser == null) return Author();

    return uCtrl.currentUser.value!;
  }

  @override
  void onInit() {
    freeOldPosts();
    listenToFollowing();
    super.onInit();
  }

  Future<List<FeedView>> loadMoreForYou([
    QueryMode mode = QueryMode.normal,
  ]) async {
    final posts = await repo.queryAdvanced(
      mode: mode,
      conditions: {'type': 'post'},
    );
    if (posts.isEmpty) return [];

    for (final p in posts) {
      listenToPost(p.id);
    }

    return mapToFeed(posts);
  }

  Future<List<FeedView>> loadUserQuoteForYou([
    QueryMode mode = QueryMode.normal,
  ]) async {
    final posts = await repo.queryAdvanced(conditions: {}, mode: mode);
    if (posts.isEmpty) return [];

    for (final p in posts) {
      listenToPost(p.id);
    }

    return mapToFeed(posts);
  }

  Future<List<FeedView>> loadMoreFollowing(
    AsList ids, [
    QueryMode mode = QueryMode.normal,
  ]) async {
    if (ids.isEmpty) return [];

    final chunks = ids.chunked(10);
    final posts = <Feed>[];
    for (final ids in chunks) {
      final part = await repo.query(values: ids, mode: mode);

      posts.addAll(part);
    }

    return mapToFeed(posts);
  }

  void listenToPost(String pid) {
    if (dataMapping.containsKey(pid)) return;
    _postSub = repo.stream$(pid).listen((p) => dataMapping[pid] = p);
  }

  void listenToFollowing() {
    if (currentUid.isEmpty) return;

    _userSub = repo.followingIds(currentUid).listen((act) {
      final incoming = act.map((a) => a.targetId).toSet();
      final current = followingIds.toSet();

      // add new
      followingIds.addAll(incoming.difference(current));

      // remove unfollowed
      followingIds.removeWhere((id) => !incoming.contains(id));
    });
  }

  void freeOldPosts({int keep = 50}) {
    if (dataMapping.length <= keep) return;

    final keys = dataMapping.keys.toList();
    final removeCount = keys.length - keep;

    for (int i = 0; i < removeCount; i++) {
      final id = keys[i];
      dataMapping.remove(id);
      _postSub?.cancel();
    }
  }

  Future<List<FeedView>> loadUserPosts(
    String uid, [
    QueryMode mode = QueryMode.normal,
  ]) async {
    final posts = await repo.queryAdvanced(
      mode: mode,
      conditions: {
        'uid': uid,
        'type': ['post', 'quote'],
      },
    );

    if (posts.isEmpty) return const [];

    final postItems = posts
        .map((post) {
          if (post.type == Post.quote && post.pid.isNotEmpty) {
            final original = dataMapping[post.pid];
            return FeedView(
              uid: uid,
              feed: post,
              parent: original,
              kind: FeedKind.quote,
              created: post.createdAt,
              rid: buildRowId(kind: FeedKind.quote, pid: post.id),
            );
          }

          return FeedView(
            uid: uid,
            feed: post,
            created: post.createdAt,
            rid: buildRowId(pid: post.id),
          );
        })
        .whereType<FeedView>()
        .toList();

    return postItems;
  }

  Future<List<FeedView>> loadUserReposts(
    String uid, [
    QueryMode mode = QueryMode.normal,
  ]) async {
    final actions = await repo.loadReposts(uid);
    final actionBypid = {for (final a in actions) a.currentId: a};
    final ids = actions.map((a) => a.currentId).toList();
    final posts = await repo.getInOrder(ids, mode: mode);

    return posts
        .map((post) {
          final action = actionBypid[post.id];
          if (action == null) return null;

          return FeedView(
            feed: post,
            uid: uid,
            kind: FeedKind.repost,
            created: action.createdAt,
            rid: buildRowId(kind: FeedKind.repost, pid: post.id, uid: uid),
          );
        })
        .whereType<FeedView>()
        .toList();
  }

  Future<List<FeedView>> loadUserMedia(
    String uid, [
    QueryMode mode = QueryMode.normal,
  ]) async {
    final posts = await repo.queryAdvanced(
      mode: mode,
      conditions: {
        'uid': uid,
        'type': ['post', 'quote'],
      },
    );

    if (posts.isEmpty) return const [];

    return mapToFeed(
      uid: uid,
      type: FeedKind.media,
      posts.where((m) => m.media.isNotEmpty).toList(),
    );
  }

  //Load Favorites
  Future<List<FeedView>> loadUserFavorites(
    String uid, [
    QueryMode mode = QueryMode.normal,
  ]) async {
    final actions = await repo.loadFavorites(uid);
    print(actions.length);
    final ids = actions.map((a) => a.currentId).toList();
    if (ids.isEmpty) return [];

    final posts = await repo.getInOrder(ids, mode: mode);
    return mapToFeed(posts, type: FeedKind.favorite, uid: uid);
  }

  Future<List<FeedView>> loadUserComments(
    String uid, [
    QueryMode mode = QueryMode.normal,
  ]) async {
    final posts = await repo.loadComments(uid, mode: mode);
    if (posts.isEmpty) return const [];

    return mapToFeed(posts, type: FeedKind.comment, uid: uid);
  }

  ///Load Bookmarks
  Future<List<FeedView>> loadUserBookmarks(
    String uid, [
    QueryMode mode = QueryMode.normal,
  ]) async {
    final actions = await repo.loadBookmarks(uid);
    final ids = actions.map((a) => a.currentId).toList();
    if (ids.isEmpty) return [];

    final posts = await repo.getInOrder(ids, mode: mode);
    return mapToFeed(posts, type: FeedKind.bookmark, uid: uid);
  }

  @override
  void onClose() {
    _postSub?.cancel();
    _userSub?.cancel();
    super.onClose();
  }
}
