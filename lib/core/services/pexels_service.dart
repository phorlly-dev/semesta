import 'package:dio/dio.dart';
import 'package:semesta/app/utils/type_def.dart';
import 'package:semesta/core/mixins/firebase_path_mixin.dart';

class PexelsService with FirebasePathMixin {
  Dio get _dio =>
      Dio(BaseOptions(baseUrl: 'https://api.pexels.com/v1/', headers: headers));

  Future<List<AsMap>> getCuratedPhotos({int perPage = 10}) async {
    final res = await _dio.get(
      'curated',
      queryParameters: {'per_page': perPage},
    );
    final List photos = res.data['photos'];
    return photos.cast<AsMap>();
  }

  Future<List<AsMap>> searchVideos(String query, {int perPage = 10}) async {
    final res = await _dio.get(
      'https://api.pexels.com/videos/search',
      queryParameters: {'query': query, 'per_page': perPage},
    );
    final List videos = res.data['videos'];
    return videos.cast<AsMap>();
  }

  Future<List<AsMap>> videosOrImages({int perPage = 10}) async {
    final res = await _dio.get(
      'https://api.pexels.com/videos/popular',
      queryParameters: {'per_page': perPage},
    );

    final List videos = res.data['videos'];
    return videos.cast<AsMap>();
  }

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
