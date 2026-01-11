import 'package:get/get.dart';
import 'package:semesta/core/repositories/generic_repository.dart';
import 'package:semesta/core/repositories/post_repository.dart';
import 'package:semesta/core/repositories/user_repository.dart';

class RepositoryBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(UserRepository());
    Get.put(PostRepository());
    Get.put(GenericRepository());
  }
}
