import 'package:semesta/core/services/storage_folder.dart';

class FirebaseCollection extends StorageFolder {
  String get users => 'users';
  String get posts => 'posts';
  String get comments => 'comments';
  String get stories => 'stories';
  String get chatrooms => 'chatrooms';
  String get messages => 'messages';

  final headers = {
    'Authorization': 'F2bPptP8Pub3LnUYk8QAQRa154PGIqYPhISawkulDX2Q4bgPVE9LCaKA',
  };
}
