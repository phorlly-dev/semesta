import 'package:semesta/app/utils/type_def.dart';
import 'package:semesta/core/models/post_action_model.dart';
import 'package:semesta/core/models/post_model.dart';
import 'package:semesta/core/repositories/generic_repository.dart';
import 'package:semesta/core/repositories/post_action_repository.dart';
import 'package:semesta/core/repositories/repository.dart';
import 'package:semesta/core/repositories/user_action_repository.dart';
import 'package:semesta/core/repositories/user_repository.dart';

class PostRepository extends IRepository<PostModel> {
  UserRepository get usr => UserRepository();
  UserActionRepository get usrAc => UserActionRepository();
  GenericRepository get gen => GenericRepository();
  PostActionRepository get act => PostActionRepository();

  Future<void> insert(PostModel model) async {
    if (model.parentId.isNotEmpty && model.type == PostType.reply) {
      final doc = getPath(parent: replies);
      doc.set(model.copyWith(id: doc.id).toMap());
      await setAction(doc.id);
    } else if (model.parentId.isNotEmpty && model.type == PostType.quote) {
      final doc = getPath(parent: reposts);
      doc.set(model.copyWith(id: doc.id).toMap());
      await usr.toggleCount(child: model.userId);
      await setAction(doc.id);
    } else {
      final postId = await store(model);
      await usr.toggleCount(child: model.userId);
      await setAction(postId);
    }
  }

  Future<void> setAction(String postId) async {
    await getPath(
      parent: postActions,
      child: postId,
    ).set(PostActionModel(postId: postId).toMap());
  }

  Future<List<PostModel>> getReplies(String parentId) async {
    final parentRef = getPath(child: parentId);
    final snapshot = await parentRef.collection('replies').get();

    return snapshot.docs.map((doc) => PostModel.fromMap(doc.data())).toList();
  }

  Future<List<PostModel>> getQuotes(String parentId) async {
    final parentRef = getPath(child: parentId);
    final snapshot = await parentRef.collection('reposts').get();

    return snapshot.docs.map((doc) => PostModel.fromMap(doc.data())).toList();
  }

  Future<List<PostModel>> getRepliesByUser(String userId) async {
    final data = await firestore
        .collectionGroup('replies')
        .where('user_id', isEqualTo: userId)
        .get();

    return data.docs.map((d) => PostModel.fromMap(d.data())).toList();
  }

  Future<List<PostModel>> getQuotesByUser(String userId) async {
    final data = await firestore
        .collectionGroup('reposts')
        .where('user_id', isEqualTo: userId)
        .where('content', isNotEqualTo: '')
        .get();

    return data.docs.map((d) => PostModel.fromMap(d.data())).toList();
  }

  @override
  String get collectionPath => posts;

  @override
  PostModel fromMap(AsMap map, String id) =>
      PostModel.fromMap({...map, '_id': id});

  @override
  AsMap toMap(PostModel model) => model.toMap();
}
