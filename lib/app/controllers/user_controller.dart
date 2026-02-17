import 'dart:async';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:semesta/app/models/mention.dart';
import 'package:semesta/public/extensions/array_extension.dart';
import 'package:semesta/public/helpers/generic_helper.dart';
import 'package:semesta/public/mixins/repository_mixin.dart';
import 'package:semesta/app/controllers/auth_controller.dart';
import 'package:semesta/app/controllers/controller.dart';
import 'package:semesta/app/models/author.dart';
import 'package:semesta/public/helpers/audit_view.dart';
import 'package:semesta/public/utils/type_def.dart';

class UserController extends IController<AuthedView> {
  final currentUid = ''.obs;
  final currentUser = Rxn<Author>(null);
  final _loggedUser = Get.put(AuthController()).currentUser;

  @override
  void onInit() {
    ever(_loggedUser, _onAuthChanged);
    super.onInit();
  }

  final Mapper<Cacher<AuthedView>> _states = {};
  Cacher<AuthedView> stateFor(String key) {
    return _states.putIfAbsent(key, () => Cacher<AuthedView>());
  }

  StreamSubscription? _userSub;
  void _onAuthChanged(User? loggedIn) {
    if (loggedIn == null) {
      // Logged out → clear data
      currentUser.value = null;
      currentUid.value = '';
    } else {
      // Logged in → fetch new data
      _userSub = urepo.sync$(loggedIn.uid).listen((u) {
        currentUid.value = u.id;
        currentUser.value = u;
      });
    }
  }

  AsWait modifyProfile(Author model, [File? avatar, File? cover]) async {
    await handleAsync(() => urepo.updateUser(model, avatar, cover));
  }

  Wait<Author?> loadUser(String uid, [String uname = '']) {
    return urepo.view(uid, other: uname);
  }

  AsWait toggleFollow(String targetId) async {
    final uid = currentUid.value;
    if (uid.isEmpty || targetId.isEmpty) return;

    await urepo.toggleFollow(uid, targetId);
  }

  Waits<AuthedView> loadUserFollowing(
    String uid, [
    QueryMode mode = QueryMode.normal,
  ]) async {
    final actions = await urepo.getFollows(uid);
    final keys = actions.toKeys((value) => value.did);
    final users = await urepo.getInOrder(keys, mode: mode);
    return users.fromFollow(actions, (value) => value.did);
  }

  Waits<AuthedView> loadUserFollowers(
    String uid, [
    QueryMode mode = QueryMode.normal,
  ]) async {
    final actions = await urepo.getFollows(uid, i: false);
    final keys = actions.toKeys((value) => value.sid);
    final users = await urepo.getInOrder(keys, mode: mode);
    return users.fromFollow(actions, (value) => value.sid);
  }

  Waits<Mention> loadMentions(String input) async {
    final actions = await urepo.getFollows(currentUid.value, limit: 10);
    final keys = actions.toKeys((value) => value.did);
    final data = await urepo.getMentions(input, keys);
    return data.where((e) => e.id != currentUid.value).toList();
  }

  @override
  void onClose() {
    _userSub?.cancel();
    super.onClose();
  }
}
