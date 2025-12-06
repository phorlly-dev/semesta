import 'package:dio/dio.dart';
import 'package:semesta/app/utils/type_def.dart';
import 'package:semesta/core/services/firebase_path.dart';

class PexelsService extends FirebaseCollection {
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
}
