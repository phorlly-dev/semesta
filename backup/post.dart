    //====================================Handle Hashtags================================================
  // AsWait makeHashtag(WriteBatch run, AsList tags) async {
  //   if (tags.isEmpty) return;

  //   // Remove duplicates early
  //   final uniqueTags = tags.toSet();

  //   // Pre-calculate shared values
  //   final today = now.todayKey;
  //   final add = FieldValue.increment(1);
  //   final merge = SetOptions(merge: true);
  //   final docId = FieldPath.documentId;
  //   final time = FieldValue.serverTimestamp();
  //   final start = now.subtract(const Duration(days: 3)).todayKey;

  //   for (final tag in uniqueTags) {
  //     final id = tag.toLowerCase();
  //     final ref = collection(hashtags).doc(id);
  //     final col = ref.collection(dailyCounts);
  //     final sref = col.doc(today);

  //     ///Cached
  //     Hashtag? hashtag;
  //     DailyCount? dailyCount;

  //     // Keep sequential reads in transaction
  //     final hashDoc = await ref.get();
  //     if (hashDoc.exists) {
  //       hashtag = Hashtag.fromState(hashDoc.data() ?? const {});
  //     }

  //     final dailyDoc = await sref.get();
  //     if (dailyDoc.exists) {
  //       dailyCount = DailyCount.fromState(dailyDoc.data() ?? const {});
  //     }

  //     // Calculate recent total and score
  //     final total = await col
  //         .orderBy(docId, descending: true)
  //         .where(docId, isGreaterThanOrEqualTo: start)
  //         .get()
  //         .then(
  //           (snap) => snap.docs.fold<int>(0, (val, doc) {
  //             return val + DailyCount.fromState(doc.data()).counts;
  //           }),
  //         );
  //     final score = (total * 3 + (hashtag?.counts ?? 0 * 0.2)).toDouble();

  //     // Update documents
  //     run.set(ref, {
  //       'id': id,
  //       'name': tag,
  //       'counts': add,
  //       'scores': score,
  //       'banned': false,
  //       'last_used_at': time,
  //       'created_at': hashtag?.createdAt ?? time,
  //     }, merge);

  //     run.set(sref, {
  //       'id': today,
  //       'counts': add,
  //       'created_at': dailyCount?.createdAt ?? time,
  //     }, merge);
  //   }
  // }

//======================Delete Post=================
//  AsWait destroyPost(Feed post, [String col = comments]) async {
//     final id = post.id;
//     final pid = post.pid;
//     final ref = collection(colName);

//     clearCached(id);
//     await submit((run) async {
//       switch (post.type) {
//         case Create.quote:
//           run.delete(ref.doc(id));
//           run.update(ref.doc(pid), toggleStats(FeedKind.quotes, -1));
//           await run.commit();
//           break;

//         case Create.reply:
//           run.delete(ref.doc(pid).collection(col).doc(id));
//           run.update(ref.doc(pid), toggleStats(FeedKind.replies, -1));
//           await run.commit();
//           break;

//         default:
//           run.delete(ref.doc(id));
//           await run.commit();
//       }
//     });
//   }

//=======================Create Post==============================
//  AsWait insert(Feed model) async {
//     assert(model.uid.isNotEmpty);

//     final id = model.pid;
//     final ref = collection(colName);

//     await submit((run) async {
//       switch (model.type) {
//         // ─────────────────────────────────────────────
//         // COMMENT
//         // ─────────────────────────────────────────────
//         case Create.reply:
//           assert(id.isNotEmpty);

//           final parentRef = ref.doc(id);
//           final childRef = parentRef.collection(comments).doc();
//           final payload = model
//               .copyWith(id: childRef.id, pid: parentRef.id)
//               .toPayload();

//           run.set(childRef, payload);
//           run.update(parentRef, toggleStats(FeedKind.replies));
//           await run.commit();
//           break;

//         // ─────────────────────────────────────────────
//         // QUOTE (standalone post with reference)
//         // ─────────────────────────────────────────────
//         case Create.quote:
//           assert(id.isNotEmpty);

//           final newRef = ref.doc();
//           final parentRef = ref.doc(id);
//           final payload = model.copyWith(id: newRef.id, pid: id).toPayload();

//           run.set(newRef, payload);
//           run.update(parentRef, toggleStats(FeedKind.quotes));
//           await run.commit();
//           break;

//         // ─────────────────────────────────────────────
//         // ORIGINAL POST
//         // ─────────────────────────────────────────────
//         default:
//           final newRef = ref.doc();
//           final payload = model.copyWith(id: newRef.id).toPayload();
//           run.set(newRef, payload);
//           await run.commit();
//       }
//     });
//   }

//=================Toggle Post================================
  // AsWait toggleReaction(
  //   ActionTarget target,
  //   String uid, [
  //   ActionType type = ActionType.like,
  // ]) => switch (type) {
  //   ActionType.like => switch (target) {
  //     ParentTarget(:final pid) => toggle(pid, uid),
  //     ChildTarget(:final pid, :final cid) => subtoggle(pid, cid, uid),
  //   },
  //   ActionType.save => switch (target) {
  //     ParentTarget(:final pid) => toggle(pid, uid, FeedKind.saves),
  //     ChildTarget(:final pid, :final cid) => subtoggle(
  //       pid,
  //       cid,
  //       uid,
  //       kind: FeedKind.saves,
  //     ),
  //   },
  //   ActionType.repost => switch (target) {
  //     ParentTarget(:final pid) => toggle(pid, uid, FeedKind.reposts),
  //     ChildTarget(:final pid, :final cid) => subtoggle(
  //       pid,
  //       cid,
  //       uid,
  //       kind: FeedKind.reposts,
  //     ),
  //   },
  // };