import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:semesta/core/mixins/repo_mixin.dart';
import 'package:semesta/app/utils/cached_helper.dart';
import 'package:semesta/core/controllers/auth_controller.dart';
import 'package:semesta/core/controllers/controller.dart';
import 'package:semesta/core/models/author.dart';
import 'package:semesta/core/repositories/user_repository.dart';
import 'package:semesta/core/views/audit_view.dart';

class UserController extends IController<AuthedView> {
  StreamSubscription? _userSub, _currentUserSub;
  final _repo = UserRepository();
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
      _currentUserSub = _repo.stream$(firebaseUser.uid).listen((u) {
        currentUid.value = u.id;
        currentUser.value = u;
      });
    }
  }

  Future<void> loadInfo() async {
    final data = await _repo.index(limit: 100);
    if (data.isEmpty) return;

    for (final u in data) {
      listenToUser(u.id);
    }
  }

  Future<void> toggleFollow(String targetId) async {
    final uid = currentUid.value;
    if (uid.isEmpty || targetId.isEmpty) return;

    await _repo.toggleFollow(uid, targetId);
  }

  void listenToUser(String uid) {
    _userSub = _repo.stream$(uid).listen((u) => dataMapping[uid] = u);
  }

  Future<List<AuthedView>> loadUserFollowing(
    String uid, [
    QueryMode mode = QueryMode.normal,
  ]) async {
    final actions = await _repo.getFollowing(uid);
    final ids = actions.map((a) => a.targetId).toList();
    if (ids.isEmpty) return const [];

    final users = await _repo.getInOrder(ids, mode: mode);
    return users.map((u) => AuthedView(u)).toList();
  }

  Future<List<AuthedView>> loadUserFollowers(
    String uid, [
    QueryMode mode = QueryMode.normal,
  ]) async {
    final actions = await _repo.getFollowers(uid);
    final ids = actions.map((a) => a.currentId).toList();
    if (ids.isEmpty) return const [];

    final users = await _repo.getInOrder(ids, mode: mode);
    return users.map((u) => AuthedView(u)).toList();
  }

  @override
  void onClose() {
    _userSub?.cancel();
    _currentUserSub?.cancel();
    super.onClose();
  }
}
