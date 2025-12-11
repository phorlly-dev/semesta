import 'dart:async';
import 'package:semesta/app/utils/custom_toast.dart';
import 'package:semesta/core/controllers/post_list_controller.dart';
import 'package:semesta/core/models/post_model.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

class PostController extends PostListController {
  Future<void> save(PostModel model, List<AssetEntity> files) async {
    await handleAsync(
      callback: () async {
        final user = currentUser;
        final media = await repo.gen.uploadMedia(currentId, files.toList());

        final copy = model.copyWith(
          media: media,
          userId: user.id,
          displayName: user.name,
          username: user.username,
          userAvatar: user.avatar,
        );

        await repo.insert(copy);
        postsForYou
          ..insert(0, copy)
          ..refresh();
        CustomToast.info('Posted.!');
      },
      onError: (err) => CustomToast.error(err.toString()),
    );
  }

  Future<void> saveChange(String postId, Map<String, dynamic> data) async {
    if (postId.isEmpty) return;
    await handleAsync(
      callback: () async {
        await repo.modify(postId, data);
        CustomToast.info('Post updated.!');
      },
    );
  }

  Future<void> remove(String postId, String userId) async {
    if (postId.isEmpty && userId.isEmpty) return;
    await tryCatch(
      callback: () async {
        final post = dataMapping[postId]!;
        if (post.media.isNotEmpty) {
          for (final m in post.media) {
            await repo.gen.deleteFile(m.path); // ✅ use stored path
          }
        }

        await repo.destroy(postId);
        await repo.usr.toggleCount(child: userId, delta: -1);

        elements
          ..removeWhere((e) => e.id == postId)
          ..refresh();
        postsForYou
          ..removeWhere((e) => e.id == postId)
          ..refresh();
        CustomToast.success('Post deleted.!');
      },
    );
  }

  Future<void> toggleFollow(String userId, bool isFollow) async {
    if (userId.isEmpty) return;
    await tryCatch(
      callback: () async {
        if (isFollow) {
          // Unfollow
          await userCtrl.toggleFollow(userId);
          postsFollowing
            ..removeWhere((e) => e.userId == userId)
            ..refresh();
        } else {
          // Follow
          await userCtrl.toggleFollow(userId);
          final data = await repo.query(field: 'user_id', value: userId);
          postsFollowing
            ..insertAll(0, data)
            ..refresh();
        }
      },
    );
  }

  Future<void> toggleLike(String postId, bool isLiked) async {
    if (isLiking[postId] == true) return; // skip if still processing
    isLiking[postId] = true;

    if (currentId.isEmpty && postId.isEmpty) return;
    await tryCatch(
      callback: () async {
        await repo.act.toggle(postId, currentId, field: 'liked');

        if (isLiked) {
          likes
            ..removeWhere((e) => e.id == postId)
            ..refresh();
        } else {
          final like = dataMapping[postId];
          likes
            ..insert(0, like!)
            ..refresh();
        }
      },
      onFinal: (val) => isLiking[postId] = val,
    );
  }

  Future<void> toggleSave(String postId, bool isLiked) async {
    if (currentId.isEmpty && postId.isEmpty) return;
    await tryCatch(
      callback: () async {
        await repo.act.toggle(postId, currentId, field: 'saved');

        if (isLiked) {
          saves
            ..removeWhere((e) => e.id == postId)
            ..refresh();
          CustomToast.warning('Post removed from your Bookmarks');
        } else {
          final data = dataMapping[postId];
          saves
            ..insert(0, data!)
            ..refresh();
          CustomToast.info('Post added to your Bookmarks');
        }
      },
    );
  }

  Future<void> toggleRepost(String postId, bool isReposted) async {
    if (currentId.isEmpty && postId.isEmpty) return;
    await tryCatch(
      callback: () async {
        await repo.act.toggle(postId, currentId, field: 'reposted');

        if (isReposted) {
          reposts
            ..removeWhere((e) => e.id == postId)
            ..refresh();
          CustomToast.warning('Repost removed from posts.');
        } else {
          final data = dataMapping[postId];
          reposts
            ..insert(0, data!)
            ..refresh();
          CustomToast.info('Repost added to posts.');
        }
      },
    );
  }

  Future<void> clearAllSaves() async {
    if (currentId.isEmpty) return;
    await tryCatch(
      callback: () async {
        await repo.act.clearAllSaves(currentId);
        saves
          ..clear()
          ..refresh();

        CustomToast.success('All bookmarks cleared');
      },
    );
  }
}


      // // Fetch normal posts (the user's own)
      //   final ownIterable = await repo.query(field: 'user_id', value: userId);
      //   final own = ownIterable.toList().cast<PostModel>();

      //   // Fetch reposts
      //   final repostIds = await repo.act.getActions(
      //     userId,
      //     currentUserId: currentUser?.id,
      //     field: 'reposted',
      //   );
      //   final reposts = repostIds.isNotEmpty
      //       ? (await repo.query(values: repostIds)).toList().cast<PostModel>()
      //       : <PostModel>[];

      //   // Combine and sort
      //   final combined = <PostModel>[...own, ...reposts];
      //   combined.sort((a, b) => b.createdAt!.compareTo(a.createdAt!));

      //   this.reposts.assignAll(combined.toList());