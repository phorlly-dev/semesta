//Firestore collectiuons
import 'package:get/get.dart';
import 'package:semesta/core/controllers/auth_controller.dart';
import 'package:semesta/core/controllers/direction_controller.dart';
import 'package:semesta/app/routes/routes.dart';
import 'package:semesta/core/controllers/action_controller.dart';
import 'package:semesta/core/controllers/post_controller.dart';
import 'package:semesta/core/controllers/user_controller.dart';
import 'package:semesta/core/repositories/generic_repository.dart';
import 'package:semesta/core/repositories/post_repository.dart';
import 'package:semesta/core/repositories/user_repository.dart';

//Collections
const users = 'users';
const posts = 'posts';
const favorites = 'favorites';
const bookmarks = 'bookmarks';
const reposts = 'reposts';
const quotes = 'quotes';
const comments = 'comments';
const shares = 'shares';
const followers = 'followers';
const following = 'following';
const messages = 'messages';
const settings = 'settings';
const unames = 'usernames';

//Storage
const avatars = 'avatars';
const images = 'images';
const thumbnails = 'thumbnails';
const videos = 'videos';

///Key Field
const id = 'id';
const userId = 'uid';
const postId = 'pid';
const type = 'type';
const post = 'post';
const quote = 'quote';
const made = 'created_at';
const currentId = 'current_id';
const targetId = 'target_id';
const public = 'everyone';
const visibility = 'visible';

Routes get route => Routes();
DateTime get now => DateTime.now();
PostRepository get prepo => Get.put(PostRepository());
UserRepository get urepo => Get.put(UserRepository());
UserController get uctrl => Get.find<UserController>();
AuthController get octrl => Get.find<AuthController>();
PostController get pctrl => Get.find<PostController>();
ActionController get actrl => Get.find<ActionController>();
GenericRepository get grepo => Get.put(GenericRepository());
DirectionController get dctrl => Get.find<DirectionController>();

String countKey([String key = reposts]) => '${key}_count';
String toCapitalize(String? name) => name?.capitalize ?? '';
String get unfollow {
  return 'Their posts will no longer show up in your home timeline. You can still view their profile, unless their posts are proteted.';
}
