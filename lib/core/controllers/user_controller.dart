import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:semesta/core/controllers/auth_controller.dart';
import 'package:semesta/core/controllers/controller.dart';
import 'package:semesta/core/models/user_model.dart';
import 'package:semesta/core/repositories/user_repository.dart';

class UserController extends IController<UserModel> {
  final _userRepo = UserRepository();

  @override
  void onInit() {
    super.onInit();
    ever(Get.put(AuthController()).currentUser, _onAuthChanged);
  }

  void _onAuthChanged(User? firebaseUser) {
    if (firebaseUser == null) {
      // Logged out → clear data
      item.value = null;
    } else {
      // Logged in → fetch new data
      showProfile(firebaseUser.uid);
    }
  }

  Future<UserModel?> showProfile(String id) async {
    final data = await _userRepo.show(id);
    item.value = data;

    return data;
  }
}
