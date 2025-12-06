import 'dart:async';
import 'package:get/get.dart';
import 'package:semesta/app/functions/json_helpers.dart';
import 'package:semesta/app/utils/custom_toast.dart';
import 'package:semesta/app/utils/extension.dart';
import 'package:semesta/core/controllers/controller.dart';
import 'package:semesta/core/controllers/user_controller.dart';
import 'package:semesta/core/models/post_action_model.dart';
import 'package:semesta/core/models/post_model.dart';
import 'package:semesta/core/models/user_model.dart';
import 'package:semesta/core/repositories/post_repository.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

class PostController extends IController<PostModel> {
  StreamSubscription? _userSub, _postSub;
  DateTime? lastFetch;
  final repo = PostRepository();
  final userCtrl = Get.put(UserController(), permanent: true);
  final postsForYou = <PostModel>[].obs;
  final postsFollowing = <PostModel>[].obs;
  final postsMap = <String, Rx<PostModel>>{}.obs;
  final followingsMap = <String, List<String>>{}.obs;

  UserModel? get currentUser => userCtrl.currentUser.value;

  @override
  void onInit() {
    loadData();
    super.onInit();
  }

  Future<void> many({
    bool following = false,
    List<String>? uids,
    bool force = false,
  }) async {
    await handleAsyncOperation(
      callback: () async {
        if (!force &&
            lastFetch != null &&
            DateTime.now().difference(lastFetch!).inMinutes < 5 &&
            postsForYou.isNotEmpty) {
          return;
        }

        lastFetch = DateTime.now();

        if (following) {
          // Prevent fetching all posts if no followings exist
          if (uids == null || uids.isEmpty) {
            postsFollowing.clear();
            return;
          }

          final chunks = uids.chunked(10);
          final all = <PostModel>[];

          for (final ids in chunks) {
            final part = await repo.query(
              field: 'user_id',
              values: ids.toList(),
            );
            all.addAll(part);
          }

          all.shuffle(rand);
          postsFollowing.assignAll(all.toList());
        } else {
          final data = await repo.index();
          data.shuffle(rand);

          postsForYou.assignAll(data.toList());
        }
      },
    );
  }

  Future<void> one(String uid) async {
    await handleAsyncOperation(
      callback: () async {
        element.value = await repo.show(uid);
      },
    );
  }

  Future<void> save(PostModel model, List<AssetEntity> files) async {
    await handleAsyncOperation(
      callback: () async {
        final user = currentUser!;
        final media = await repo.gen.uploadMedia(user.id, files.toList());

        final copy = model.copyWith(
          media: media,
          userId: user.id,
          displayName: user.name,
          username: user.username,
          userAvatar: user.avatar,
        );

        await repo.insert(copy);
        CustomToast.success('Posted.!');

        postsForYou.insert(0, copy); // instant local UI update
      },
      onError: (err) => CustomToast.error(err.toString()),
    );
  }

  Future<void> saveChange(
    String id,
    Map<String, dynamic> data, [
    String? uid,
  ]) async {
    await handleAsyncOperation(
      callback: () async {
        await repo.modify(id, data);
      },
    );
  }

  Future<void> remove(String id, String uid) async {
    await handleAsyncOperation(
      callback: () async {
        final post = await repo.show(id);
        if (post?.media != null) {
          for (final m in post!.media) {
            await repo.gen.deleteFile(m.path); // ✅ use stored path
          }
        }

        await repo.destroy(id);
        await repo.usr.toggleCount(child: uid, delta: -1);

        CustomToast.success('Post deleted.!');
        postsForYou.removeWhere((e) => e.id == id);
      },
    );
  }

  Future<void> toggleFollow(String userId, bool isFollow) async {
    if (isFollow) {
      // Unfollow
      postsFollowing.removeWhere((e) => e.userId == userId);
      await userCtrl.toggleFollow(userId);
    } else {
      // Follow
      final data = await repo.query(field: 'user_id', value: userId);
      postsFollowing.insertAll(0, data);
      await userCtrl.toggleFollow(userId);
    }

    // refresh the feed if needed
    postsFollowing.refresh();
  }

  Future<void> loadData() async {
    await many(force: true);
    listenToFollowings();
  }

  void listenToPost(String postId) {
    if (postsMap[postId] != null) return;

    final actStream = repo.act.liveStream(child: postId);
    final postStream = repo.liveStream(child: postId);

    _userSub = repo
        .bindStream(
          first: actStream,
          second: postStream,
          combiner: (a, b) {
            final postA = PostActionModel.fromMap(a.data()!);
            final updated = PostModel.fromMap(b.data()!);

            return updated.copyWith(action: postA);
          },
        )
        .listen((combined) {
          postsMap[postId] = (postsMap[postId] ?? Rx(combined))
            ..value = combined;
        });
  }

  void listenToFollowings() {
    final uid = currentUser?.id;
    if (uid == null) return;

    _postSub = repo.live(
      child: uid,
      parent: 'user_actions',
      onStream: (doc) async {
        final followings = parseToList(doc.data()?['followings']);

        // Keep a map of userId -> followings list
        followingsMap[uid] = followings;
        followingsMap.refresh(); // <== triggers Obx rebuilds

        // Optional: immediately update following feed
        if (followings.isEmpty) {
          postsFollowing.clear();
          return;
        }

        final chunks = followings.chunked(10);
        final all = <PostModel>[];

        for (final c in chunks) {
          final part = await repo.query(field: 'user_id', values: c);
          all.addAll(part.toList());
        }

        postsFollowing.assignAll(all.toList());
      },
    );
  }

  @override
  void onClose() {
    _userSub?.cancel();
    _postSub?.cancel();
    super.onClose();
  }
}
