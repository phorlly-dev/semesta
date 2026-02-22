import 'dart:io';
import 'package:semesta/app/models/media.dart';
import 'package:semesta/app/services/storage_service.dart';
import 'package:semesta/public/helpers/generic_helper.dart';
import 'package:semesta/public/mixins/user_mixin.dart';
import 'package:semesta/public/utils/type_def.dart';
import 'package:semesta/app/models/author.dart';
import 'package:semesta/app/repositories/repository.dart';

class UserRepository extends IRepository<Author> with UserMixin {
  AsWait createUser(Author model) {
    return collection(users).doc(model.id).set(model.toPayload());
  }

  AsWait updateUser(Author model, [File? avatarFile, File? coverFile]) async {
    final ki = model.id;
    final media = model.media;
    final ref = collection(users).doc(ki);

    // Upload new files if provided
    final avatarMedia = await pushFile(ki, avatarFile, StoredIn.avatar);
    final coverMedia = await pushFile(ki, coverFile, StoredIn.cover);

    // Update user model with new file URLs
    clearCached(ki);
    final cached = Media(
      url: avatarMedia?.url ?? media.url,
      path: avatarMedia?.path ?? media.path,
      others: coverMedia != null
          ? [coverMedia.url, coverMedia.path]
          : media.others,
    );
    final updatedUser = model.copyWith(edited: true, media: cached);
    return ref.update(updatedUser.toPayload());
  }

  AsWait toggleFollow(String iid, String uid) async {
    if (iid == uid) return;

    invalidateFollowCache(iid);
    invalidateFollowCache(uid);
    return callable('onFollow', {'target_id': uid});
  }

  @override
  String get colName => users;

  @override
  Author fromState(AsMap map) => Author.fromState(map);

  @override
  AsMap toPayload(Author model) => model.toPayload();
}
