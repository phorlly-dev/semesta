import 'package:semesta/core/models/user_model.dart';
import 'package:semesta/core/repositories/repository.dart';

class UserRepository extends IRepository<UserModel> {
  Future<void> createUser(String userId, UserModel model) async {
    final newUser = UserModel(
      id: userId,
      email: model.email,
      name: model.name,
      avatar: model.avatar,
      gender: model.gender,
      birthday: model.birthday ?? DateTime.now().add(Duration(days: 365 * 16)),
    );

    await firestore.collection(collectionPath).doc(userId).set(newUser.toMap());
  }

  Future<bool> isNotExist(String userId) async {
    final userDoc = await firestore
        .collection(collectionPath)
        .doc(userId)
        .get();

    if (!userDoc.exists) return true;

    return false;
  }

  @override
  String get collectionPath => users;

  @override
  UserModel fromMap(Map<String, dynamic> map, String id) =>
      UserModel.fromMap({...map, 'id': id});

  @override
  Map<String, dynamic> toMap(UserModel model) => model.toMap();

  final pics = [
    'https://i.pravatar.cc/150?img=0',
    'https://i.pravatar.cc/150?img=1',
    'https://i.pravatar.cc/150?img=2',
    'https://i.pravatar.cc/150?img=3',
    'https://i.pravatar.cc/150?img=4',
    'https://i.pravatar.cc/150?img=5',
    'https://i.pravatar.cc/150?img=6',
    'https://i.pravatar.cc/150?img=7',
    'https://i.pravatar.cc/150?img=8',
    'https://i.pravatar.cc/150?img=9',
  ];
}
