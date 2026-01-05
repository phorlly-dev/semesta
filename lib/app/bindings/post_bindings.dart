import 'package:get/get.dart';
import 'package:semesta/core/controllers/action_controller.dart';
import 'package:semesta/core/controllers/post_controller.dart';

class PostBindings extends Bindings {
  @override
  void dependencies() {
    Get.put(PostController());
    Get.put(ActionController());
  }
}
