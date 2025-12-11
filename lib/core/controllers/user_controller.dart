import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:semesta/core/controllers/auth_controller.dart';
import 'package:semesta/core/controllers/controller.dart';
import 'package:semesta/core/models/user_action_model.dart';
import 'package:semesta/core/models/user_model.dart';
import 'package:semesta/core/repositories/user_repository.dart';

class UserController extends IController<UserModel> {
  StreamSubscription? _userSub, _currentUserSub;
  final currentId = ''.obs;
  final repo = UserRepository();
  final currentUser = Rxn<UserModel>(null);
  final _loggedUser = Get.put(AuthController(), permanent: true).currentUser;
  final followers = <UserModel>[].obs;
  final followings = <UserModel>[].obs;

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
      currentId.value = '';
    } else {
      // Logged in → fetch new data
      _currentUserSub = repo.live(
        child: firebaseUser.uid,
        onStream: (doc) {
          final updated = UserModel.fromMap(doc.data()!);
          currentId.value = updated.id;
          currentUser.value = updated;
        },
      );
    }
  }

  Future<void> loadInfo() async {
    final data = await repo.index();
    for (final u in data) {
      listenToUser(u.id);
    }
  }

  Future<void> toggleFollow(String targetId) async {
    final uid = currentId.value;
    if (uid.isEmpty && targetId.isEmpty) return;
    await tryCatch(
      callback: () async {
        await repo.act.toggleFollow(uid, targetId);
      },
      onFinal: (_) {
        listenToUser(uid);
        listenToUser(targetId);
      },
    );
  }

  void listenToUser(String userId) {
    final userStream = repo.liveStream(child: userId);
    final actStream = repo.act.liveStream(child: userId);

    _userSub = repo
        .bindStream(
          first: userStream,
          second: actStream,
          combiner: (usr, act) {
            final usrAc = UserActionModel.fromMap(act.data()!);
            final updated = UserModel.fromMap(usr.data()!, action: usrAc);

            return updated;
          },
        )
        .listen((combined) => dataMapping[userId] = combined);
  }

  Future<void> loadFollowings(String userId) async {
    await handleAsync(
      callback: () async {
        final ids = await repo.act.getActions(userId);
        if (ids.isEmpty) return;

        final data = await repo.query(values: ids.toList());
        followings
          ..assignAll(data.toList())
          ..refresh();
      },
    );
  }

  Future<void> loadFollowers(String userId) async {
    await handleAsync(
      callback: () async {
        final ids = await repo.act.getActions(userId, field: 'followers');
        if (ids.isEmpty) return;

        final data = await repo.query(values: ids.toList());
        followers
          ..assignAll(data.toList())
          ..refresh();
      },
    );
  }

  @override
  void onClose() {
    _userSub?.cancel();
    _currentUserSub?.cancel();
    dataMapping.clear();
    super.onClose();
  }
}
