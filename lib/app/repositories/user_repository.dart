import 'dart:io';
import 'package:semesta/app/models/asset.dart';
import 'package:semesta/app/services/storage_service.dart';
import 'package:semesta/public/helpers/feed_view.dart';
import 'package:semesta/public/helpers/generic_helper.dart';
import 'package:semesta/public/mixins/user_mixin.dart';
import 'package:semesta/public/utils/type_def.dart';
import 'package:semesta/app/models/author.dart';
import 'package:semesta/app/models/reaction.dart';
import 'package:semesta/app/repositories/repository.dart';

class UserRepository extends IRepository<Author> with UserMixin {
  AsWait createUser(Author model, [String filePath = '']) async {
    final uref = collection(users).doc(model.id);
    final aref = collection(assets).doc(model.uname);
    final payload = Asset(
      id: model.id,
      name: model.name,
      uname: model.uname,
      avatar: filePath,
    ).to();

    await execute((run) async => run.set(uref, model.to()).set(aref, payload));
  }

  AsWait updateUser(Author model, [File? avatarFile, File? coverFile]) async {
    final uref = collection(users).doc(model.id);
    final aref = collection(assets).doc(model.uname);

    await execute((run) async {
      // Upload new files if provided
      final avatar = await pushFile(model.id, avatarFile, StoredIn.avatar);
      final cover = await pushFile(model.id, coverFile, StoredIn.cover);

      // Update user model with new file URLs
      final updatedUser = model.copy(
        avatar: avatar?.display,
        cover: cover?.display,
      );

      // Fetch existing asset data
      String? ap, cp;
      final res = await run.get(aref);

      if (res.exists) {
        final asset = Asset.from(res.data()!);
        ap = asset.avatar;
        cp = asset.cover;

        // Delete old files only if new ones were uploaded
        if (avatarFile != null && ap.isNotEmpty) {
          await deleteFile(ap);
        }

        if (coverFile != null && cp.isNotEmpty) {
          await deleteFile(cp);
        }
      }

      // Create updated asset with new or existing paths
      final updatedAsset = Asset(
        id: model.id,
        name: model.name,
        uname: model.uname,
      ).copy(avatar: avatar?.path ?? ap, cover: cover?.path ?? cp);

      // Batch update both documents
      run.update(uref, updatedUser.to());
      run.update(aref, updatedAsset.to());
    });
  }

  AsWait toggleFollow(String me, String them) async {
    if (me == them) return;

    final meRef = collection(path).doc(me);
    final themRef = collection(path).doc(them);

    // 🔐 Source of truth
    final followingRef = meRef.collection(following).doc(them);
    final followerRef = themRef.collection(followers).doc(me);

    await execute((run) async {
      // Check the EDGE, not the user
      final edgeSnap = await run.get(followingRef);

      // Read counts once (prevents negative drift)
      final meSnap = await run.get(meRef);
      final themSnap = await run.get(themRef);

      final meFollowing = (meSnap.data()?[following] ?? 0) as int;
      final themFollowers = (themSnap.data()?[followers] ?? 0) as int;

      if (edgeSnap.exists) {
        // -------- UNFOLLOW --------
        run.delete(followingRef);
        run.delete(followerRef);
        run.update(meRef, {following: meFollowing > 0 ? meFollowing - 1 : 0});
        run.update(themRef, {
          followers: themFollowers > 0 ? themFollowers - 1 : 0,
        });
      } else {
        // -------- FOLLOW --------
        final data = Reaction(
          currentId: me,
          targetId: them,
          kind: FeedKind.following,
        );

        run.set(followingRef, data.to());
        run.set(followerRef, data.copy(kind: FeedKind.follower).to());
        run.update(meRef, {following: meFollowing + 1});
        run.update(themRef, {followers: themFollowers + 1});
      }
    });
  }

  @override
  String get path => users;

  @override
  Author from(AsMap map) => Author.from(map);

  @override
  AsMap to(Author model) => model.to();
}
