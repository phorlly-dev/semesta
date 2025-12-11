import 'dart:async';

import 'package:get/get.dart';
import 'package:semesta/app/functions/json_helpers.dart';
import 'package:semesta/app/utils/extension.dart';
import 'package:semesta/core/controllers/controller.dart';
import 'package:semesta/core/controllers/user_controller.dart';
import 'package:semesta/core/models/post_action_model.dart';
import 'package:semesta/core/models/post_model.dart';
import 'package:semesta/core/models/user_model.dart';
import 'package:semesta/core/repositories/post_repository.dart';

class PostListController extends IController<PostModel> {
  StreamSubscription? _userSub, _postSub;
  final repo = PostRepository();
  final userCtrl = Get.put(UserController(), permanent: true);

  //Public
  final followings = <String>[].obs;
  final postsForYou = <PostModel>[].obs;
  final postsFollowing = <PostModel>[].obs;

  //Private
  final replies = <PostModel>[].obs;
  final reposts = <PostModel>[].obs;
  final likes = <PostModel>[].obs;
  final saves = <PostModel>[].obs;
  final quotes = <PostModel>[].obs;
  final media = <PostModel>[].obs;
  final Map<String, bool> isLiking = {};

  @override
  void onInit() {
    loadData();
    super.onInit();
  }

  Future<void> loadData() async {
    await loadMoreForYou();
    listenToFollowings();
  }

  Future<void> loadMoreForYou([bool isRandom = true]) async {
    await handleAsync(
      callback: () async {
        final data = await repo.index();
        if (isRandom) data.shuffle(rand);

        for (final p in data) {
          listenToPost(p.id);
        }

        freeOldPosts();
        postsForYou
          ..assignAll(data)
          ..refresh();
      },
    );
  }

  Future<void> loadMoreFollowing(List<String> userIds) async {
    if (userIds.isEmpty) {
      postsFollowing.clear();
      return;
    }
    await handleAsync(
      callback: () async {
        final chunks = userIds.chunked(10);
        final data = <PostModel>[];

        for (final ids in chunks) {
          final part = await repo.query(field: 'user_id', values: ids.toList());
          data.addAll(part);
        }

        data.shuffle(rand);
        postsFollowing
          ..assignAll(data)
          ..refresh();
      },
    );
  }

  Future<void> loadPosts(String userId) async {
    await handleAsync(
      callback: () async {
        final data = await repo.query(field: 'user_id', value: userId);
        elements
          ..assignAll(data)
          ..refresh();
      },
    );
  }

  Future<void> loadMedia(String userId) async {
    await handleAsync(
      callback: () async {
        final data = await repo.query(field: 'user_id', value: userId);
        media
          ..assignAll(data)
          ..refresh();
      },
    );
  }

  void listenToPost(String postId) {
    if (dataMapping.containsKey(postId)) return;

    final actStream = repo.act.liveStream(child: postId);
    final postStream = repo.liveStream(child: postId);

    _postSub = repo
        .bindStream(
          first: postStream,
          second: actStream,
          combiner: (pst, act) {
            final postA = PostActionModel.fromMap(act.data()!);
            final updated = PostModel.fromMap(pst.data()!, action: postA);

            return updated;
          },
        )
        .listen((combined) => dataMapping[postId] = combined);
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

  void listenToFollowings() {
    if (currentId.isEmpty) return;

    _userSub = repo.live(
      child: currentId,
      parent: 'user_actions',
      onStream: (doc) async {
        final fIds = parseToList(doc.data()?['followings']);

        // Keep a map of userId -> followings list
        followings.value = fIds;
        followings.refresh();

        // Optional: immediately update following feed
        if (followings.isEmpty) {
          postsFollowing.clear();
          return;
        }

        final chunks = followings.chunked(10);
        final data = <PostModel>[];

        for (final c in chunks) {
          final part = await repo.query(field: 'user_id', values: c);
          data.addAll(part.toList());
        }

        postsFollowing
          ..assignAll(data)
          ..refresh();
      },
    );
  }

  Future<void> loadLikes(String userId) async {
    await handleAsync(
      callback: () async {
        final ids = await repo.act.getActions(userId);
        if (ids.isEmpty) return;

        final data = await repo.query(values: ids.toList());
        likes
          ..assignAll(data)
          ..refresh();
      },
    );
  }

  Future<void> loadSaves(String userId) async {
    await handleAsync(
      callback: () async {
        final ids = await repo.act.getActions(userId, field: 'saved');
        if (ids.isEmpty) return;

        final data = await repo.query(values: ids.toList());
        saves
          ..assignAll(data)
          ..refresh();
      },
    );
  }

  Future<void> loadReposts(String userId) async {
    await handleAsync(
      callback: () async {
        final ids = await repo.act.getActions(userId, field: 'reposted');
        if (ids.isEmpty) return;

        final data = await repo.query(values: ids.toList());
        reposts
          ..assignAll(data)
          ..refresh();
      },
    );
  }

  String get currentId => userCtrl.currentId.value;
  UserModel get currentUser {
    final currentUser = userCtrl.currentUser.value;
    if (currentUser == null) return UserModel();

    return userCtrl.currentUser.value!;
  }

  bool isCurrentUser(String userId) {
    return currentId.isNotEmpty && currentId == userId;
  }

  @override
  void onClose() {
    _userSub?.cancel();
    _postSub?.cancel();
    dataMapping.clear();
    super.onClose();
  }
}
