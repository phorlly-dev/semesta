import 'package:semesta/core/models/post_model.dart';
import 'package:semesta/core/repositories/repository.dart';

class PostRepository extends IRepository<PostModel> {
  @override
  String get collectionPath => posts;

  @override
  PostModel fromMap(Map<String, dynamic> map, String id) =>
      PostModel.fromMap({...map, '_id': id});

  @override
  Map<String, dynamic> toMap(PostModel model) => model.toMap();
}
