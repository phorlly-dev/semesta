import 'package:get/get.dart';
import 'package:semesta/core/controllers/post_controller.dart';
import 'package:semesta/core/controllers/story_controller.dart';
import 'package:semesta/core/repositories/post_repository.dart';
import 'package:semesta/core/repositories/story_repository.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => PostRepository());
    Get.lazyPut(() => StoryRepository());
    Get.lazyPut(() => StoryController(repository: Get.find()));
    Get.lazyPut(() => PostController(repository: Get.find()));
  }
}
