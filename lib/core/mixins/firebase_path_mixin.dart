mixin FirebasePathMixin {
  //Firestore collectiuons
  String get users => 'users';
  String get posts => 'posts';
  String get favorites => 'favorites';
  String get bookmarks => 'bookmarks';
  String get reposts => 'reposts';
  String get quotes => 'quotes';
  String get comments => 'comments';
  String get shares => 'shares';
  String get followers => 'followers';
  String get following => 'following';

  String get messages => 'messages';
  String get settings => 'settings';
  String get usernames => 'usernames';

  //Storage
  String get avatars => 'avatars';
  String get images => 'images';
  String get thumbnails => 'thumbnails';
  String get videos => 'videos';

  final headers = {
    'Authorization': 'F2bPptP8Pub3LnUYk8QAQRa154PGIqYPhISawkulDX2Q4bgPVE9LCaKA',
  };
}
