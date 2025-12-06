class FirebaseCollection {
  //Firestore collectiuons
  String get users => 'users';
  String get posts => 'posts';
  String get messages => 'messages';
  String get settings => 'settings';
  String get userActions => 'user_actions';
  String get postActions => 'post_actions';
  String get usernames => 'usernames';
  String get replies => 'replies';
  String get reposts => 'reposts';

  //Storage
  String get avatars => 'avatars';
  String get images => 'images';
  String get videos => 'videos';

  final headers = {
    'Authorization': 'F2bPptP8Pub3LnUYk8QAQRa154PGIqYPhISawkulDX2Q4bgPVE9LCaKA',
  };
}
