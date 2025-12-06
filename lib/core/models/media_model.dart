import 'package:semesta/app/utils/type_def.dart';

enum MediaType { image, video, gif, background }

class MediaModel {
  final String display;
  final String path;
  final MediaType type;
  final int? width;
  final int? height;

  const MediaModel({
    this.width,
    this.height,
    required this.display,
    this.type = MediaType.image,
    required this.path,
  });

  factory MediaModel.fromMap(AsMap map) => MediaModel(
    display: map['display'],
    path: map['path'],
    type: MediaType.values.firstWhere(
      (e) => e.name == map['type'],
      orElse: () => MediaType.image,
    ),
    width: map['width'],
    height: map['height'],
  );

  AsMap toMap() => {
    'display': display,
    'type': type.name,
    'width': width,
    'height': height,
    'path': path,
  };
}
