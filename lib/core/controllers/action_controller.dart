import 'dart:async';
import 'package:get/get.dart';
import 'package:semesta/app/functions/custom_toast.dart';
import 'package:semesta/core/views/generic_helper.dart';
import 'package:semesta/core/controllers/post_controller.dart';
import 'package:semesta/core/controllers/user_controller.dart';
import 'package:semesta/core/views/class_helper.dart';
import 'package:semesta/core/views/utils_helper.dart';

class ActionController extends GetxController {
  ///Playload
  final pCtrl = Get.put(PostController());
  UserController get uCtrl => pCtrl.uCtrl;

  String get currentUid => pCtrl.currentUid;
  bool isCurrentUser(String uid) => pCtrl.isCurrentUser(uid);
  String get _hKey => getKey();
  String get _pKey => getKey(uid: currentUid, screen: Screen.post);
  String get _fKey => getKey(uid: currentUid, screen: Screen.favorite);
  String get _bKey => getKey(uid: currentUid, screen: Screen.bookmark);
  String get _cKey => getKey(uid: currentUid, screen: Screen.comment);

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
      final rid = getRowId(pid: pid, uid: currentUid, kind: FeedKind.favorite);
      pCtrl.clearFor(_fKey, rid);
      pCtrl.metaFor(_pKey).dirty = true;
    } else {
      pCtrl.metaFor(_fKey).dirty = true;
    }
  }

  Future<void> toggleBookmark(
    ActionTarget target,
    String pid, {
    bool active = false,
  }) async {
    await prepo.toggleBookmark(target, currentUid);
    final rid = getRowId(pid: pid, uid: currentUid, kind: FeedKind.bookmark);
    if (active) {
      pCtrl.clearFor(_bKey, rid);
      CustomToast.warning('Removed from Bookmaks', title: 'Bookmaks');
    } else {
      CustomToast.info('Added to Bookmaks', title: 'Bookmaks');
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
      final rid = getRowId(pid: pid, uid: currentUid, kind: FeedKind.repost);
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
