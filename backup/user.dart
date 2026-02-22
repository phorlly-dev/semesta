//====================================Toggle Follow================================================
// AsWait toggleMember(String i, String u) async {
//   if (i == u) return;

//   final meRef = collection(colName).doc(i);
//   final themRef = collection(colName).doc(u);

//   // 🔐 Source of truth
//   final followingRef = meRef.collection(following).doc(u);
//   final followerRef = themRef.collection(followers).doc(i);

//   await execute((run) async {
//     // Check the EDGE, not the user
//     final edgeSnap = await run.get(followingRef);

//     // Read counts once (prevents negative drift)
//     final meSnap = await run.get(meRef);
//     final themSnap = await run.get(themRef);

//     final meFollowing = (meSnap.data()?[following] ?? 0) as int;
//     final themFollowers = (themSnap.data()?[followers] ?? 0) as int;

//     if (edgeSnap.exists) {
//       // -------- UNFOLLOW --------
//       run.delete(followingRef);
//       run.delete(followerRef);
//       run.update(meRef, {following: meFollowing > 0 ? meFollowing - 1 : 0});
//       run.update(themRef, {
//         followers: themFollowers > 0 ? themFollowers - 1 : 0,
//       });
//       invalidateFollowCache(i);
//       invalidateFollowCache(u);
//     } else {
//       // -------- FOLLOW --------
//       final data = Reaction(id: i, did: u, kind: FeedKind.following);

//       run.set(followingRef, data.toPayload());
//       run.set(
//         followerRef,
//         data.copyWith(kind: FeedKind.followers).toPayload(),
//       );
//       run.update(meRef, {following: meFollowing + 1});
//       run.update(themRef, {followers: themFollowers + 1});
//     }
//   });
// }

//===============================Create Account========================================
// AsWait createUser(Author model) async {
//   final ki = model.id;
//   final ku = model.uname;

//   final uref = collection(users).doc(model.id);
//   final mref = collection(mentions).doc(ku.toLowerCase());

//   final payload = Mention(
//     id: ki,
//     url: url,
//     uname: ku,
//     name: model.name,
//   ).toPayload();

//   await uref.set(model.toPayload());

//   await submit((run) async {
//     run.set(uref, model.toPayload());
//     // run.set(mref, payload);
//     await run.commit();
//   });
// }

//================================Update Profile=======================
  // AsWait updateUser(Author model, [File? avatarFile, File? coverFile]) async {
  //   final ki = model.id;
  //   final ku = model.uname;
  //   final media = model.media;

  //   final uref = collection(users).doc(ki);
  //   // final mref = collection(mentions).doc(ku.toLowerCase());

  //   // Upload new files if provided
  //   final avatarMedia = await pushFile(ki, avatarFile, StoredIn.avatar);
  //   final coverMedia = await pushFile(ki, coverFile, StoredIn.cover);

  //   // Update user model with new file URLs
  //   final cached = Media(
  //     url: avatarMedia?.url ?? media.url,
  //     path: avatarMedia?.path ?? media.path,
  //     others: coverMedia != null ? [coverMedia.url, coverMedia.path] : const [],
  //   );
  //   final updatedUser = model.copyWith(edited: true, media: cached);

  //   // Delete old files only if new ones were uploaded
  //   if (avatarFile != null && media.path.isNotEmpty) {
  //     await deleteFile(media.path);
  //   }

  //   final coverPath = media.others;
  //   if (coverFile != null && coverPath.isNotEmpty) {
  //     await deleteFile(coverPath[1]);
  //   }

  //   // Create updated asset with new or existing colNames
  //   final updatedMention = Mention(
  //     id: ki,
  //     uname: ku,
  //     name: model.name,
  //     verified: model.verified,
  //     createdAt: model.createdAt,
  //     url: avatarMedia?.url ?? media.url,
  //   ).copyWith();

  //   // Batch update both documents
  //   await submit((run) async {
  //     run.update(uref, updatedUser.toPayload());
  //     run.update(mref, updatedMention.toPayload());
  //     await run.commit();
  //     clearCached(ki);
  //   });
  // }
