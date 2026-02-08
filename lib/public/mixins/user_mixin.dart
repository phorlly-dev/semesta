import 'package:semesta/public/helpers/generic_helper.dart';
import 'package:semesta/app/models/reaction.dart';
import 'package:semesta/app/models/author.dart';
import 'package:semesta/app/repositories/repository.dart';
import 'package:semesta/public/utils/type_def.dart';

mixin UserMixin on IRepository<Author> {
  Sync<bool> follow$(String me, String them, [bool i = true]) => i
      ? has$('$users/$me/$following/$them')
      : has$('$users/$them/$following/$me');

  Waits<Reaction> getFollow(String uid, {int limit = 30, bool i = true}) => i
      ? getReactions({currentId: uid}, limit: limit, col: following)
      : getReactions({targetId: uid}, limit: limit);

  Waits<Reaction> getFollowing(String uid, [int limit = 30]) {
    return getReactions({currentId: uid}, limit: limit, col: following);
  }
}
