import 'dart:async';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:semesta/public/helpers/generic_helper.dart';
import 'package:semesta/public/helpers/vendor_helper.dart';
import 'package:semesta/public/mixins/repo_mixin.dart';
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

  final Mapper<Cacher<AuthedView>> _states = {};
  Cacher<AuthedView> stateFor(String key) {
    return _states.putIfAbsent(key, () => Cacher<AuthedView>());
  }

  @override
  void onInit() {
    ever(_loggedUser, _onAuthChanged);
    _loadInfo();
    super.onInit();
  }

  void _onAuthChanged(User? loggedIn) {
    if (loggedIn == null) {
      // Logged out → clear data
      currentUser.value = null;
      currentUid.value = '';
    } else {
      // Logged in → fetch new data
      _currentUserSub = urepo.sync$(loggedIn.uid).listen((u) {
        currentUid.value = u.id;
        currentUser.value = u;
      });
    }
  }

  AsWait modifyProfile(Author model, [File? avatar, File? cover]) async {
    await handleAsync(() => urepo.updateUser(model, avatar, cover));
  }

  AsWait _loadInfo() async {
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

  Waits<AuthedView> loadUserFollowing(
    String uid, [
    QueryMode mode = QueryMode.normal,
  ]) async {
    final actions = await urepo.getFollow(uid);
    final users = await urepo.getInOrder(
      getKeys(actions, (value) => value.targetId),
      mode: mode,
    );

    return users.isNotEmpty
        ? mapToFollow(users, actions, (value) => value.targetId)
        : const [];
  }

  Waits<AuthedView> loadUserFollowers(
    String uid, [
    QueryMode mode = QueryMode.normal,
  ]) async {
    final actions = await urepo.getFollow(uid, i: false);
    final users = await urepo.getInOrder(
      getKeys(actions, (value) => value.currentId),
      mode: mode,
    );

    return users.isNotEmpty
        ? mapToFollow(users, actions, (value) => value.currentId)
        : const [];
  }

  @override
  void onClose() {
    _userSub?.cancel();
    _currentUserSub?.cancel();
    super.onClose();
  }
}
