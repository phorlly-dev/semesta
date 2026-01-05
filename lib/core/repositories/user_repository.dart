import 'package:semesta/app/functions/format.dart';
import 'package:semesta/core/mixins/user_mixin.dart';
import 'package:semesta/app/utils/type_def.dart';
import 'package:semesta/core/models/author.dart';
import 'package:semesta/core/repositories/repository.dart';

class UserRepository extends IRepository<Author> with UserMixin {
  Future<void> createUser(Author model, [String? path]) async {
    final newUser = Author(
      id: model.id,
      email: model.email,
      name: model.name,
      avatar: model.avatar,
      uname: model.uname,
      dob: model.dob ?? now.add(Duration(days: 365 * 16)),
      createdAt: now,
      updatedAt: now,
    );

    await collection(users)
        .doc(model.id)
        .set(newUser.to())
        .catchError(
          (e) => throw Exception('Failed to create user: ${e.toString()}'),
        );
    await setUsername(model.id, model.uname, path);
  }

  Future<void> setUsername(String uid, String uname, [String? path]) async {
    await collection(usernames)
        .doc(uname)
        .set({'uid': uid, 'path': path, 'uname': uname.trim()})
        .catchError((e) => throw Exception('Username $uname is already taken'));
  }

  @override
  String get path => users;

  @override
  Author from(AsMap map, String id) => Author.from({...map, 'id': id});

  @override
  AsMap to(Author model) => model.to();
}
