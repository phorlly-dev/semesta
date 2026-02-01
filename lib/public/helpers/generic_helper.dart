import 'package:get/get.dart';
import 'package:semesta/app/controllers/auth_controller.dart';
import 'package:semesta/routes/routes.dart';
import 'package:semesta/app/controllers/post_controller.dart';
import 'package:semesta/app/controllers/user_controller.dart';
import 'package:semesta/app/repositories/generic_repository.dart';
import 'package:semesta/app/repositories/post_repository.dart';
import 'package:semesta/app/repositories/user_repository.dart';
import 'package:semesta/app/controllers/action_controller.dart';
import 'package:semesta/app/controllers/direction_controller.dart';

//Collections
const users = 'users';
const posts = 'posts';
const favorites = 'likes';
const bookmarks = 'saves';
const reposts = 'reposts';
const comments = 'replies';
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
const keyId = 'id';
const userId = 'uid';
const postId = 'pid';
const made = 'created_at';
const currentId = 'current_id';
const targetId = 'target_id';
const public = 'everyone';
const visibility = 'visible';
const types = {
  'type': ['post', 'quote'],
};

///Helpers
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

///Misc
String toCapitalize(String? name) => name?.capitalize ?? '';
String get unfollow {
  return 'Their posts will no longer show up in your home timeline. You can still view their profile, unless their posts are proteted.';
}
