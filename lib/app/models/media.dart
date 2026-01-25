import 'package:semesta/public/functions/func_helper.dart';
import 'package:semesta/public/utils/type_def.dart';

enum MediaType { image, video, gif, background }

class Media {
  final String display;
  final String path;
  final MediaType type;
  final AsMap thumbnails;

  const Media({
    required this.display,
    this.type = MediaType.image,
    required this.path,
    this.thumbnails = const {},
  });

  factory Media.from(AsMap map) => Media(
    display: map['display'],
    path: map['path'],
    thumbnails: parseToMap(map['thumbnails']),
    type: MediaType.values.firstWhere(
      (e) => e.name == map['type'],
      orElse: () => MediaType.image,
    ),
  );

  AsMap to() => {
    'display': display,
    'thumbnails': thumbnails,
    'type': type.name,
    'path': path,
  };
}
