import 'dart:async';
import 'package:get/get.dart';
import 'package:semesta/core/controllers/post_controller.dart';
import 'package:semesta/core/controllers/user_controller.dart';
import 'package:semesta/core/repositories/post_repository.dart';
import 'package:semesta/core/views/helper.dart';

class ActionController extends GetxController {
  ///Playload
  final pCtrl = Get.put(PostController());
  PostRepository get repo => pCtrl.repo;
  UserController get uCtrl => pCtrl.uCtrl;

  String get currentUid => pCtrl.currentUid;
  bool isCurrentUser(String uid) => pCtrl.isCurrentUser(uid);

  Future<void> toggleFollow(String uid, bool active) async {
    await uCtrl.toggleFollow(uid);
    if (!active) pCtrl.metaFor('home:following').dirty = true;
  }

  Future<void> toggleFavorite(
    ActionTarget target,
    String pid, {
    bool active = false,
  }) async {
    await repo.toggleFavorite(target, currentUid);
    if (active) {
      final rid = buildRowId(
        pid: pid,
        uid: currentUid,
        kind: FeedKind.favorite,
      );
      pCtrl.clearFor('profile:$currentUid:favorites', rid);
      pCtrl.metaFor('profile:$currentUid:posts').dirty = true;
    } else {
      pCtrl.metaFor('profile:$currentUid:favorites').dirty = true;
    }
  }

  Future<void> toggleBookmark(
    ActionTarget target,
    String pid, {
    bool active = false,
  }) async {
    await repo.toggleBookmark(target, currentUid);
    final rid = buildRowId(pid: pid, uid: currentUid, kind: FeedKind.bookmark);
    if (active) pCtrl.clearFor('user:$currentUid:bookmarks', rid);
  }

  Future<void> toggleRepost(
    ActionTarget target,
    String pid, {
    bool active = false,
  }) async {
    await repo.toggleRepost(target, currentUid);
    pCtrl.metaFor('profile:$currentUid:favorites').dirty = true;
    pCtrl.metaFor('profile:$currentUid:comments').dirty = true;

    if (!active) {
      pCtrl.addRepostToTabs('profile:$currentUid:posts', pid);
    } else {
      final rid = buildRowId(pid: pid, uid: currentUid, kind: FeedKind.repost);
      pCtrl.clearFor('profile:$currentUid:posts', rid);
    }
  }
}
