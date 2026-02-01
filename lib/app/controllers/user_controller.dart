import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:semesta/public/helpers/generic_helper.dart';
import 'package:semesta/public/helpers/vendor_helper.dart';
import 'package:semesta/public/mixins/repo_mixin.dart';
import 'package:semesta/public/helpers/cached_helper.dart';
import 'package:semesta/app/controllers/auth_controller.dart';
import 'package:semesta/app/controllers/controller.dart';
import 'package:semesta/app/models/author.dart';
import 'package:semesta/public/helpers/audit_view.dart';
import 'package:semesta/public/utils/type_def.dart';

class UserController extends IController<AuthedView> {
  StreamSubscription? _userSub, _currentUserSub;
  final _loggedUser = Get.put(AuthController()).currentUser;

  final currentUid = ''.obs;
  final dataMapping = <String, Author>{}.obs;
  final currentUser = Rxn<Author>(null);

  final Map<String, CachedState<AuthedView>> _states = {};
  CachedState<AuthedView> stateFor(String key) {
    return _states.putIfAbsent(key, () => CachedState<AuthedView>());
  }

  @override
  void onInit() {
    ever(_loggedUser, _onAuthChanged);
    loadInfo();
    super.onInit();
  }

  void _onAuthChanged(User? firebaseUser) {
    if (firebaseUser == null) {
      // Logged out → clear data
      currentUser.value = null;
      currentUid.value = '';
    } else {
      // Logged in → fetch new data
      _currentUserSub = urepo.sync$(firebaseUser.uid).listen((u) {
        currentUid.value = u.id;
        currentUser.value = u;
      });
    }
  }

  AsWait loadInfo() async {
    final data = await urepo.index(limit: 100);
    if (data.isEmpty) return;

    for (final u in data) {
      listenToUser(u.id);
    }
  }

  AsWait toggleFollow(String targetId) async {
    final uid = currentUid.value;
    if (uid.isEmpty || targetId.isEmpty) return;

    await urepo.toggleFollow(uid, targetId);
  }

  void listenToUser(String uid) {
    _userSub = urepo.sync$(uid).listen((u) => dataMapping[uid] = u);
  }

  Wait<List<AuthedView>> loadUserFollowing(
    String uid, [
    QueryMode mode = QueryMode.normal,
  ]) async {
    final actions = await urepo.getFollowing(uid);
    final ids = actions.map((a) => a.targetId).toList();
    final users = await urepo.getInOrder(ids, mode: mode);

    if (users.isEmpty) return const [];

    return mapToFollow(users, actions, (value) => value.targetId);
  }

  Wait<List<AuthedView>> loadUserFollowers(
    String uid, [
    QueryMode mode = QueryMode.normal,
  ]) async {
    final actions = await urepo.getFollowers(uid);
    final ids = actions.map((a) => a.currentId).toList();
    final users = await urepo.getInOrder(ids, mode: mode);

    if (users.isEmpty) return const [];

    return mapToFollow(users, actions, (value) => value.currentId);
  }

  @override
  void onClose() {
    _userSub?.cancel();
    _currentUserSub?.cancel();
    super.onClose();
  }
}
