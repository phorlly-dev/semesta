import 'package:semesta/app/functions/format.dart';
import 'package:semesta/app/functions/logger.dart';
import 'package:semesta/core/models/reaction.dart';
import 'package:semesta/core/models/author.dart';
import 'package:semesta/core/repositories/repository.dart';

mixin UserMixin on IRepository<Author> {
  Stream<bool> iFollow$(String me, String them) {
    return has$('$users/$me/$following/$them');
  }

  Stream<bool> theyFollow$(String me, String them) {
    return has$('$users/$them/$following/$me');
  }

  Future<List<Reaction>> getFollowing(String uid, {int limit = 30}) {
    return reactions(following, uid, key: 'current_id', limit: limit);
  }

  Future<List<Reaction>> getFollowers(String uid, {int limit = 30}) {
    return reactions(followers, uid, limit: limit);
  }

  Future<void> toggleFollow(String me, String them) async {
    if (me == them) return;

    final meRef = collection(path).doc(me);
    final themRef = collection(path).doc(them);

    // 🔐 Source of truth
    final followingRef = meRef.collection(following).doc(them);
    final followerRef = themRef.collection(followers).doc(me);

    try {
      await db.runTransaction((txn) async {
        // Check the EDGE, not the user
        final edgeSnap = await txn.get(followingRef);

        // Read counts once (prevents negative drift)
        final meSnap = await txn.get(meRef);
        final themSnap = await txn.get(themRef);
        final followingField = 'following_count';
        final followersField = 'followers_count';

        final meFollowing = (meSnap.data()?[followingField] ?? 0) as int;
        final themFollowers = (themSnap.data()?[followersField] ?? 0) as int;

        if (edgeSnap.exists) {
          // -------- UNFOLLOW --------
          txn.delete(followingRef);
          txn.delete(followerRef);

          txn.update(meRef, {
            followingField: meFollowing > 0 ? meFollowing - 1 : 0,
          });

          txn.update(themRef, {
            followersField: themFollowers > 0 ? themFollowers - 1 : 0,
          });
        } else {
          // -------- FOLLOW --------
          final data = Reaction(
            currentId: me,
            targetId: them,
            createdAt: now,
          ).to();

          txn.set(followingRef, data);
          txn.set(followerRef, data);

          txn.update(meRef, {followingField: meFollowing + 1});
          txn.update(themRef, {followersField: themFollowers + 1});
        }
      });
    } catch (e, s) {
      HandleLogger.error('Toggle Follow failed', message: e, stack: s);
      rethrow;
    }
  }
}
