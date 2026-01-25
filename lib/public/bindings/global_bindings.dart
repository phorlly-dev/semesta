import 'package:get/get.dart';
import 'package:semesta/app/controllers/direction_controller.dart';
import 'package:semesta/app/controllers/auth_controller.dart';
import 'package:semesta/app/controllers/user_controller.dart';

class GlobalBindings extends Bindings {
  @override
  void dependencies() {
    Get.put(AuthController(), permanent: true);
    Get.put(UserController(), permanent: true);
    Get.put(DirectionController(), permanent: true);
  }
}
