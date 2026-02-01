import 'package:semesta/public/functions/logger.dart';
import 'package:semesta/public/helpers/generic_helper.dart';
import 'package:semesta/public/mixins/user_mixin.dart';
import 'package:semesta/public/utils/type_def.dart';
import 'package:semesta/app/models/author.dart';
import 'package:semesta/app/models/reaction.dart';
import 'package:semesta/app/repositories/repository.dart';
import 'package:semesta/public/helpers/utils_helper.dart';

class UserRepository extends IRepository<Author> with UserMixin {
  AsWait createUser(Author model, [String? path]) async {
    final newUser = Author(
      id: model.id,
      email: model.email,
      name: model.name,
      avatar: model.avatar,
      uname: model.uname,
      dob: model.dob ?? now.add(Duration(days: 365 * 16)),
      createdAt: now,
      updatedAt: now,
    );

    await collection(users)
        .doc(model.id)
        .set(newUser.to())
        .catchError(
          (e) => throw Exception('Failed to create user: ${e.toString()}'),
        );
    await setUsername(model.id, model.uname, path);
  }

  AsWait setUsername(String uid, String uname, [String? path]) async {
    await collection(unames)
        .doc(uname)
        .set({userId: uid, 'path': path, 'uname': uname.trim()})
        .catchError((e) => throw Exception('Username $uname is already taken'));
  }

  AsWait toggleFollow(String me, String them) async {
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

        final meFollowing = (meSnap.data()?[following] ?? 0) as int;
        final themFollowers = (themSnap.data()?['follower'] ?? 0) as int;

        if (edgeSnap.exists) {
          // -------- UNFOLLOW --------
          txn
            ..delete(followingRef)
            ..delete(followerRef)
            ..update(meRef, {following: meFollowing > 0 ? meFollowing - 1 : 0})
            ..update(themRef, {
              'follower': themFollowers > 0 ? themFollowers - 1 : 0,
            });
        } else {
          // -------- FOLLOW --------
          final data = Reaction(
            exist: true,
            currentId: me,
            targetId: them,
            createdAt: now,
            kind: FeedKind.following,
          );

          txn
            ..set(followingRef, data.to())
            ..set(followerRef, data.copy(kind: FeedKind.follower).to())
            ..update(meRef, {following: meFollowing + 1})
            ..update(themRef, {'follower': themFollowers + 1});
        }
      });
    } catch (e, s) {
      HandleLogger.error('Toggle Follow failed', message: e, stack: s);
      rethrow;
    }
  }

  @override
  String get path => users;

  @override
  Author from(AsMap map, String id) => Author.from({...map, 'id': id});

  @override
  AsMap to(Author model) => model.to();
}
