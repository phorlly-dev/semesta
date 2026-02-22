import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:semesta/app/models/mention.dart';
import 'package:semesta/public/functions/func_helper.dart';
import 'package:semesta/public/helpers/generic_helper.dart';
import 'package:semesta/app/models/reaction.dart';
import 'package:semesta/app/models/author.dart';
import 'package:semesta/app/repositories/repository.dart';
import 'package:semesta/public/utils/type_def.dart';

mixin UserMixin on IRepository<Author> {
  final Map<String, List<Reaction>> _followCache = {};
  String _key(String uid, int limit, bool i) {
    return '$uid-$limit-${i ? following : followers}';
  }

  void invalidateFollowCache(String uid) {
    _followCache.removeWhere((key, _) => key.startsWith('$uid-'));
  }

  Sync<bool> follow$(String me, String them, [bool i = true]) => i
      ? has$('$users/$me/$following/$them')
      : has$('$users/$them/$following/$me');

  Waits<Reaction> getFollows(
    String uid, {
    int limit = 30,
    bool i = true,
  }) async {
    final key = _key(uid, limit, i);
    if (_followCache.containsKey(key)) return _followCache[key]!;

    final data = i
        ? await getReactions({keyId: uid}, limit: limit, col: following)
        : await getReactions({targetId: uid}, limit: limit);

    _followCache[key] = data;
    return data;
  }

  Waits<Mention> getMentions(
    String input,
    AsList keys, {
    int limit = 10,
    String key = keyId,
  }) async {
    final text = input.toLowerCase();
    final docId = FieldPath.documentId;

    Query<AsMap> res = collection(mentions).limit(limit);
    res = input.isEmpty
        ? res.orderBy(docId).where(key, whereIn: keys)
        : res.orderBy(docId).startAt([text]).endAt(['$text\uf8ff']);

    return getMore(await res.get(), Mention.fromState);
  }
}
