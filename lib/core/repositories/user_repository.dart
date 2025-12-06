import 'package:semesta/app/utils/type_def.dart';
import 'package:semesta/core/models/user_action_model.dart';
import 'package:semesta/core/models/user_model.dart';
import 'package:semesta/core/repositories/repository.dart';
import 'package:semesta/core/repositories/user_action_repository.dart';

class UserRepository extends IRepository<UserModel> {
  UserActionRepository get act => UserActionRepository();

  Future<void> createUser(UserModel model, [String? path]) async {
    final now = DateTime.now();
    final newUser = UserModel(
      id: model.id,
      email: model.email,
      name: model.name,
      avatar: model.avatar,
      username: model.username,
      dob: model.dob ?? DateTime.now().add(Duration(days: 365 * 16)),
      createdAt: now,
      updatedAt: now,
    );

    await getPath(child: model.id).set(newUser.toMap());
    await getPath(
      parent: userActions,
      child: model.id,
    ).set(UserActionModel(userId: model.id).toMap());
    await setUsername(model.id, model.username, path);
  }

  Future<void> setUsername(String uid, String username, [String? path]) async {
    await getPath(
      parent: usernames,
      child: username,
    ).set({'user_id': uid, 'path': path, 'username': username.trim()});
  }

  @override
  String get collectionPath => users;

  @override
  UserModel fromMap(AsMap map, String id) =>
      UserModel.fromMap({...map, 'id': id});

  @override
  AsMap toMap(UserModel model) => model.toMap();

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
