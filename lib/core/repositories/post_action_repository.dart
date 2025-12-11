import 'package:semesta/app/functions/json_helpers.dart';
import 'package:semesta/app/utils/type_def.dart';
import 'package:semesta/core/models/post_action_model.dart';
import 'package:semesta/core/repositories/repository.dart';

class PostActionRepository extends IRepository<PostActionModel> {
  Future<void> clearAllSaves(String userId) async {
    final userRef = getPath(parent: userActions, child: userId);
    final userSnap = await userRef.get();
    final savedPosts = parseToList(userSnap['saved_posts']);

    if (savedPosts.isEmpty) return;

    final batch = firestore.batch();

    for (final postId in savedPosts) {
      final postRef = getPath(child: postId);
      final postSnap = await postRef.get();
      if (postSnap.exists) {
        final savedBy = parseToList(postSnap['saved_by']);
        savedBy.remove(userId);
        batch.update(postRef, {'saved_by': savedBy});
      }
    }

    batch.update(userRef, {'saved_posts': []});
    await batch.commit();
  }

  @override
  String get collectionPath => postActions;

  @override
  PostActionModel fromMap(AsMap map, String id) =>
      PostActionModel.fromMap({'id': id, ...map});

  @override
  AsMap toMap(PostActionModel model) => model.toMap();

  Future<List<String>> getActions(
    String userId, {
    String field = 'liked',
  }) async {
    final userDoc = await getPath(parent: userActions, child: userId).get();
    final postIds = parseToList(userDoc['${field}_posts']);

    return postIds.toList();
  }

  Future<void> toggle(
    String postId,
    String userId, {
    String field = 'liked',
  }) async {
    final postRef = getPath(child: postId);
    final userRef = getPath(parent: userActions, child: userId);

    final batch = firestore.batch();

    final postSnap = await postRef.get();
    final userSnap = await userRef.get();

    final toPosts = parseToList(postSnap['${field}_by']);
    final toUsers = parseToList(userSnap['${field}_posts']);

    final has = toPosts.contains(userId);
    if (has) {
      await toggleCount(child: postId, parent: posts, field: field, delta: -1);
      toPosts.remove(userId);
      toUsers.remove(postId);
    } else {
      await toggleCount(child: postId, parent: posts, field: field);
      toPosts.add(userId);
      toUsers.add(postId);
    }

    batch.update(postRef, {'${field}_by': toPosts.toList()});
    batch.update(userRef, {'${field}_posts': toUsers.toList()});

    await batch.commit();
  }
}
