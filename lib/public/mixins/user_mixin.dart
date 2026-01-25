import 'package:semesta/public/helpers/generic_helper.dart';
import 'package:semesta/app/models/reaction.dart';
import 'package:semesta/app/models/author.dart';
import 'package:semesta/app/repositories/repository.dart';

mixin UserMixin on IRepository<Author> {
  Stream<bool> iFollow$(String me, String them) {
    return has$('$users/$me/$following/$them');
  }

  Stream<bool> theyFollow$(String me, String them) {
    return has$('$users/$them/$following/$me');
  }

  Future<List<Reaction>> getFollowing(String uid, [int limit = 30]) {
    return getReactions(
      limit: limit,
      col: following,
      conditions: {currentId: uid},
    );
  }

  Future<List<Reaction>> getFollowers(String uid, [int limit = 30]) {
    return getReactions(conditions: {targetId: uid}, limit: limit);
  }
}
