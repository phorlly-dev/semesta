import 'package:faker/faker.dart';
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
const mentions = 'mentions';
const hashtags = 'hashtags';
const dailyCounts = 'daily_counts';

//Storage
const videos = 'videos';
const covers = 'covers';
const images = 'images';
const avatars = 'avatars';
const thumbnails = 'thumbnails';

///Key Field
const keyId = 'id';
const userId = 'uid';
const postId = 'pid';
const made = 'created_at';
const currentId = 'sid';
const targetId = 'did';
const public = 'everyone';
const visibility = 'visible';
const types = {
  'type': ['post', 'quote'],
};
const api = 'AIzaSyBM_V7DErwuC6Nk7EsDpG2Eupbmn7wNggc';
final hashtag = RegExp(r'(?<=\s|^)#([a-zA-Z0-9_]+)');
final mention = RegExp(r'@([a-zA-Z0-9_]+)');

///Helpers
Routes get routes => Routes();
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

String get fakeName => faker.person.name();
String get fakeTitle => faker.lorem.sentence();
String toCapitalize(String? name) => name?.capitalize ?? '';
String get unfollow {
  return 'Their posts will no longer show up in your home timeline. You can still view their profile, unless their posts are proteted.';
}

String get token {
  return '186960173803-q8c82j37onennb9inhf09tffh8optgq3.apps.googleusercontent.com';
}

String get http {
  return 'https://maps.googleapis.com/maps/api/place/autocomplete/json';
}
