import 'package:semesta/app/functions/json_helpers.dart';
import 'package:semesta/app/utils/type_def.dart';
import 'package:semesta/core/models/user_action_model.dart';
import 'package:semesta/core/repositories/repository.dart';

class UserActionRepository extends IRepository<UserActionModel> {
  Future<void> toggleFollow(String currentUserId, String targetUserId) async {
    if (currentUserId == targetUserId) return;

    final currentUserRef = getPath(child: currentUserId);
    final targetUserRef = getPath(child: targetUserId);

    await firestore.runTransaction((txn) async {
      final currentSnap = await txn.get(currentUserRef);
      final targetSnap = await txn.get(targetUserRef);

      final currentData = currentSnap.data() ?? {};
      final targetData = targetSnap.data() ?? {};

      final currentFollowings = parseToList(currentData['followings']);
      final targetFollowers = parseToList(targetData['followers']);

      final isAlreadyFollowing = currentFollowings.contains(targetUserId);

      if (isAlreadyFollowing) {
        // Unfollow
        currentFollowings.remove(targetUserId);
        targetFollowers.remove(currentUserId);

        toggleCount(
          child: currentUserId,
          field: 'followinged',
          delta: -1,
          parent: users,
        );
        txn.update(currentUserRef, {'followings': currentFollowings});

        toggleCount(
          child: targetUserId,
          field: 'followered',
          delta: -1,
          parent: users,
        );
        txn.update(targetUserRef, {'followers': targetFollowers});
      } else {
        // Follow
        currentFollowings.add(targetUserId);
        targetFollowers.add(currentUserId);

        toggleCount(
          child: currentUserId,
          field: 'followinged',
          delta: 1,
          parent: users,
        );
        txn.update(currentUserRef, {'followings': currentFollowings});

        toggleCount(
          child: targetUserId,
          field: 'followered',
          delta: 1,
          parent: users,
        );
        txn.update(targetUserRef, {'followers': targetFollowers});
      }
    });
  }

  @override
  String get collectionPath => userActions;

  @override
  UserActionModel fromMap(AsMap map, String id) =>
      UserActionModel.fromMap({'id': id, ...map});

  @override
  AsMap toMap(UserActionModel model) => model.toMap();

  Future<List<String>> getActions(String userId) async {
    final userDoc = await getPath(child: userId).get();
    final userIds = parseToList(userDoc['followings']);

    if (userIds.isEmpty) return [];

    return userIds.toList();
  }
}
