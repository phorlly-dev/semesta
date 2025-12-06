import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:semesta/core/controllers/auth_controller.dart';
import 'package:semesta/core/controllers/controller.dart';
import 'package:semesta/core/models/user_action_model.dart';
import 'package:semesta/core/models/user_model.dart';
import 'package:semesta/core/repositories/user_repository.dart';

class UserController extends IController<UserModel> {
  final repo = UserRepository();
  final _loggedUser = Get.put(AuthController(), permanent: true).currentUser;
  final currentUser = Rx<UserModel?>(null);
  StreamSubscription? _userSub;

  @override
  void onInit() {
    ever(_loggedUser, _onAuthChanged);
    super.onInit();
  }

  void _onAuthChanged(User? firebaseUser) {
    if (firebaseUser == null) {
      // Logged out → clear data
      currentUser.value = null;
    } else {
      // Logged in → fetch new data
      listenToUser(firebaseUser.uid); // 👈 this makes live updates work
      update();
    }
  }

  Future<void> toggleFollow(String targetId) async {
    await handleAsyncOperation(
      callback: () async {
        final uid = _loggedUser.value?.uid;
        if (uid == null) return;

        await repo.act.toggleFollow(uid, targetId);

        // Re-listen both users to refresh counts on both sides
        listenToUser(uid);
        listenToUser(targetId);
      },
    );
  }

  Future<void> one(String uid) async {
    await handleAsyncOperation(
      callback: () async {
        element.value = await repo.show(uid);
      },
    );
  }

  void listenToUser(String uid) {
    final loggedId = _loggedUser.value?.uid;
    final userStream = repo.liveStream(child: uid);
    final actStream = repo.act.liveStream(child: uid);

    _userSub = repo
        .bindStream(
          first: actStream,
          second: userStream,
          combiner: (doc, doc1) {
            final usrAc = UserActionModel.fromMap(doc.data()!);
            final updated = UserModel.fromMap(doc1.data()!);

            return updated.copyWith(action: usrAc);
          },
        )
        .listen((combined) {
          if (uid == loggedId) {
            currentUser.value = combined;
          } else {
            element.value = combined;
          }
        });
  }

  bool isCurrentUser(String userId) {
    final current = currentUser.value;
    return current != null && current.id == userId;
  }

  @override
  void onClose() {
    _userSub?.cancel();
    super.onClose();
  }
}
