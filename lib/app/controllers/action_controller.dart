import 'dart:async';
import 'package:get/get.dart';
import 'package:semesta/public/functions/custom_toast.dart';
import 'package:semesta/public/helpers/generic_helper.dart';
import 'package:semesta/app/controllers/post_controller.dart';
import 'package:semesta/app/controllers/user_controller.dart';
import 'package:semesta/public/helpers/class_helper.dart';
import 'package:semesta/public/helpers/utils_helper.dart';

class ActionController extends GetxController {
  ///Playload
  final pCtrl = Get.put(PostController());
  UserController get uCtrl => pCtrl.uCtrl;

  String get currentUid => pCtrl.currentUid;
  bool isCurrentUser(String uid) => pCtrl.isCurrentUser(uid);
  String get _hKey => getKey();
  String get _pKey => getKey(id: currentUid, screen: Screen.post);
  String get _fKey => getKey(id: currentUid, screen: Screen.favorite);
  String get _bKey => getKey(id: currentUid, screen: Screen.bookmark);
  String get _cKey => getKey(id: currentUid, screen: Screen.comment);

  Future<void> toggleFollow(String uid, bool active) async {
    await uCtrl.toggleFollow(uid);
    if (!active) pCtrl.metaFor(getKey(screen: Screen.following)).dirty = true;
  }

  Future<void> toggleFavorite(
    ActionTarget target,
    String pid, {
    bool active = false,
  }) async {
    await prepo.toggleFavorite(target, currentUid);
    if (active) {
      final rid = getRowId(pid: pid, uid: currentUid, kind: FeedKind.liked);
      pCtrl.clearFor(_fKey, rid);
    }
  }

  Future<void> toggleBookmark(
    ActionTarget target,
    String pid, {
    bool active = false,
  }) async {
    await prepo.toggleBookmark(target, currentUid);
    final rid = getRowId(pid: pid, uid: currentUid, kind: FeedKind.saved);
    if (active) {
      pCtrl.clearFor(_bKey, rid);
      CustomToast.warning('Removed from Saved', title: 'Saved');
    } else {
      CustomToast.info('Added to Saved', title: 'Saved');
    }
  }

  Future<void> toggleRepost(
    ActionTarget target,
    String pid, {
    bool active = false,
  }) async {
    await prepo.toggleRepost(target, currentUid);
    pCtrl.metaFor(_fKey).dirty = true;
    pCtrl.metaFor(_cKey).dirty = true;

    if (active) {
      final rid = getRowId(pid: pid, uid: currentUid, kind: FeedKind.reposted);
      pCtrl.clearFor(_hKey, rid);
      pCtrl.clearFor(_pKey, rid);
      pCtrl.clearFor(_cKey, rid);
      CustomToast.warning('Removed from Posts', title: 'Reposts');
    } else {
      pCtrl.addRepostToTabs(_pKey, pid);
      pCtrl.addRepostToTabs(_cKey, pid);
      CustomToast.info('Added to Posts', title: 'Reposts');
    }
  }
}
