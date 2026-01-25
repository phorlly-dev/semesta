import 'package:get/get.dart';
import 'package:semesta/app/controllers/action_controller.dart';
import 'package:semesta/app/controllers/comment_controller.dart';
import 'package:semesta/app/controllers/post_controller.dart';

class PostBindings extends Bindings {
  @override
  void dependencies() {
    Get.put(PostController());
    Get.put(ActionController());
    Get.lazyPut(() => CommentController());
  }
}
