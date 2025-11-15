import 'package:get/get.dart';
import 'package:semesta/app/utils/logger.dart';
import 'package:semesta/core/controllers/controller.dart';
import 'package:semesta/core/models/story_media_model.dart';
import 'package:semesta/core/models/story_model.dart';
import 'package:semesta/core/models/user_model.dart';
import 'package:semesta/core/repositories/story_repository.dart';
import 'package:semesta/core/repositories/user_repository.dart';
import 'package:semesta/core/services/pexels_service.dart';

class StoryController extends IController<StoryModel> {
  final StoryRepository repository;
  final pexels = PexelsService();
  final users = <UserModel>[].obs;

  StoryController({required this.repository});

  Future<void> get() async => handleAsyncOperation(
    callback: () async {
      final userRepo = UserRepository();
      final stories = await repository.viewByLimit();

      final userResults = await Future.wait(
        stories.map((s) => userRepo.show(s.userId)),
      );
      users.value = userResults.whereType<UserModel>().toList();

      items.assignAll(stories);
    },
  );

  Map<String?, UserModel> get userMap => {for (var u in users) u.id: u};

  Future<void> set(StoryModel model) async => handleAsyncOperation(
    callback: () async {
      await repository.store(model);
      items.insert(0, model);
    },
  );

  Future<void> saveChange(String id, StoryModel model) async =>
      handleAsyncOperation(
        callback: () async {
          repository.modify(id, model.toMap());
        },
      );

  Future<void> remove(String id) async => handleAsyncOperation(
    callback: () async {
      await repository.destroy(id);
      items.removeWhere((e) => e.id == id);
    },
  );

  Future<void> loadStoriesFromPexels() async => handleAsyncOperation(
    callback: () async {
      final userIds = [
        'axSsUNu46FSCUa91NWmDAlNSzD62',
        'mxQfweYsluWzTUpyf5KtHvkVdx83',
      ];

      // fetch 8 photos and 6 videos
      final photos = await pexels.videosOrImages(perPage: 8);
      final videos = await pexels.videosOrImages(perPage: 6);

      final newStories = [
        ...photos.map(
          (p) => StoryModel(
            userId: getRandomId(userIds),
            title: p['user']['name'] ?? 'Pixels Image',
            media: p['video_pictures'].map(
              (f) => StoryMediaModel(
                url: f['picture'],
                type: 'image',
                thumbnail: p['image'],
              ),
            ),
            expiresAt: DateTime.now().add(const Duration(hours: 24)),
          ),
        ),
        ...videos.map(
          (v) => StoryModel(
            userId: getRandomId(userIds),
            title: v['user']['name'] ?? 'Pexels Video',
            media: v['video_files'].map(
              (f) => StoryMediaModel(
                url: f['link'],
                type: 'video',
                thumbnail: v['image'],
                duration: Duration(minutes: v['duration'] ?? 0),
              ),
            ),
            expiresAt: DateTime.now().add(const Duration(hours: 24)),
          ),
        ),
      ];

      // Save to Firestore
      for (final story in newStories) {
        await repository.store(story);
      }

      items.assignAll(newStories);
      HandleLogger.info(
        '✅ Added ${newStories.length} Pexels stories to Firestore',
      );
    },
  );

  @override
  void onInit() {
    get();
    super.onInit();
  }
}
