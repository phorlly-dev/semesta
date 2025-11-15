import 'package:dio/dio.dart';
import 'package:semesta/core/services/firebase_collection.dart';

class PexelsService extends FirebaseCollection {
  Dio get _dio =>
      Dio(BaseOptions(baseUrl: 'https://api.pexels.com/v1/', headers: headers));

  Future<List<Map<String, dynamic>>> getCuratedPhotos({
    int perPage = 10,
  }) async {
    final res = await _dio.get(
      'curated',
      queryParameters: {'per_page': perPage},
    );
    final List photos = res.data['photos'];
    return photos.cast<Map<String, dynamic>>();
  }

  Future<List<Map<String, dynamic>>> searchVideos(
    String query, {
    int perPage = 10,
  }) async {
    final res = await _dio.get(
      'https://api.pexels.com/videos/search',
      queryParameters: {'query': query, 'per_page': perPage},
    );
    final List videos = res.data['videos'];
    return videos.cast<Map<String, dynamic>>();
  }

  Future<List<Map<String, dynamic>>> videosOrImages({int perPage = 10}) async {
    final res = await _dio.get(
      'https://api.pexels.com/videos/popular',
      queryParameters: {'per_page': perPage},
    );

    final List videos = res.data['videos'];
    return videos.cast<Map<String, dynamic>>();
  }
}
