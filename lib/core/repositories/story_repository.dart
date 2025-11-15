import 'package:semesta/core/models/story_model.dart';
import 'package:semesta/core/repositories/repository.dart';

class StoryRepository extends IRepository<StoryModel> {
  @override
  String get collectionPath => stories;

  @override
  StoryModel fromMap(Map<String, dynamic> map, String id) =>
      StoryModel.fromMap({...map, '_id': id});

  @override
  Map<String, dynamic> toMap(StoryModel model) => model.toMap();
}
