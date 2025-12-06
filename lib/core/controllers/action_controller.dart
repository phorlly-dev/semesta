import 'package:get/get.dart';
import 'package:semesta/app/utils/custom_toast.dart';
import 'package:semesta/core/controllers/post_controller.dart';
import 'package:semesta/core/models/post_model.dart';

class ActionController extends PostController {
  final replies = <PostModel>[].obs;
  final media = <PostModel>[].obs;
  final reposts = <PostModel>[].obs;
  final likes = <PostModel>[].obs;
  final saves = <PostModel>[].obs;
  final quotes = <PostModel>[].obs;
  final Map<String, bool> _isLiking = {};

  Future<void> loadPosts(String userId) async {
    if (userId.isEmpty) return;

    await handleAsyncOperation(
      callback: () async {
        final data = await repo.query(field: 'user_id', value: userId);
        elements.assignAll(data.toList());
      },
    );
  }

  Future<void> toggleLike(String postId, bool isLiked) async {
    if (_isLiking[postId] == true) return; // skip if still processing
    _isLiking[postId] = true;

    await handleAsyncOperation(
      callback: () async {
        final userId = currentUser?.id;
        if (userId == null) return;

        await repo.act.toggle(postId, userId, field: 'liked');
        if (isLiked) {
          likes.removeWhere((e) => e.id == postId);
        } else {
          final like = await repo.show(postId);
          likes.insert(0, like!);
        }

        update();
      },
      onFinal: (isEnded) => _isLiking[postId] = isEnded,
    );
  }

  Future<void> loadLikes(String userId) async {
    if (userId.isEmpty) return;

    await handleAsyncOperation(
      callback: () async {
        final curId = currentUser?.id;
        final ids = await repo.act.getActions(userId, currentUserId: curId);
        if (ids.isEmpty) return;

        final data = await repo.query(values: ids.toList());

        likes.assignAll(data.toList());
      },
    );
  }

  Future<void> toggleSave(String postId, bool isLiked) async {
    await handleAsyncOperation(
      callback: () async {
        final userId = currentUser?.id;
        if (userId == null || postId.isEmpty) return;

        await repo.act.toggle(postId, userId, field: 'saved');
        if (isLiked) {
          saves.removeWhere((e) => e.id == postId);
          CustomToast.warning('Post removed from your Bookmarks');
        } else {
          CustomToast.info('Post added to your Bookmarks');
        }

        update();
      },
    );
  }

  Future<void> loadSaves(String userId) async {
    if (userId.isEmpty) return;

    await handleAsyncOperation(
      callback: () async {
        final curId = currentUser?.id;
        final ids = await repo.act.getActions(
          userId,
          currentUserId: curId,
          field: 'saved',
        );
        if (ids.isEmpty) return;

        final data = await repo.query(values: ids.toList());

        saves.assignAll(data.toList());
      },
    );
  }

  Future<void> clearAllSaves() async {
    await handleAsyncOperation(
      callback: () async {
        final userId = currentUser?.id;
        if (userId == null) return;

        await repo.act.clearAllSaves(userId);
        saves.clear();

        CustomToast.success('All bookmarks cleared');
        update();
      },
    );
  }

  Future<void> toggleRepost(String postId, bool isReposted) async {
    await handleAsyncOperation(
      callback: () async {
        final userId = currentUser?.id;
        if (userId == null) return;

        await repo.act.toggle(postId, userId, field: 'reposted');

        if (isReposted) {
          reposts.removeWhere((e) => e.id == postId);
          CustomToast.warning('Repost removed from posts.');
        } else {
          final like = await repo.show(postId);
          reposts.insert(0, like!);
          CustomToast.success('Repost added to posts.');
        }

        update();
      },
    );
  }

  Future<void> loadReposts(String userId) async {
    if (userId.isEmpty) return;

    await handleAsyncOperation(
      callback: () async {
        final curId = currentUser?.id;
        final ids = await repo.act.getActions(
          userId,
          currentUserId: curId,
          field: 'reposted',
        );
        if (ids.isEmpty) return;

        final data = await repo.query(values: ids.toList());

        reposts.assignAll(data.toList());
      },
    );
  }

  Future<void> loadReplies(String postId) async {
    handleAsyncOperation(
      callback: () async {
        final replies = await repo.getRepliesByUser(postId);
        this.replies.assignAll(replies);
      },
    );
  }

  Future<void> loadQuotes(String postId) async {
    handleAsyncOperation(
      callback: () async {
        final quotes = await repo.getQuotes(postId);
        this.quotes.assignAll(quotes);
      },
    );
  }

  Future<void> loadProfileData(String userId) async {
    await loadPosts(userId);
    await loadReplies(userId);
    await loadQuotes(userId);
    await loadLikes(userId);
    await loadSaves(userId);
    await loadReposts(userId);
  }
}
