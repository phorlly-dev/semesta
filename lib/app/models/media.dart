import 'package:semesta/public/extensions/json_extension.dart';
import 'package:semesta/public/utils/type_def.dart';

enum MediaType { image, video, background }

class Media {
  final String url;
  final String path;
  final MediaType type;
  final AsList others;
  const Media({
    this.path = '',
    this.url = '',
    this.others = const [],
    this.type = MediaType.image,
  });

  factory Media.fromState(AsMap map) => Media(
    path: map.asText('path'),
    url: map.asText('url'),
    others: map.asArray('others'),
    type: map.asEnum('type', MediaType.values),
  );

  AsMap toPayload() => {
    'path': path,
    'type': type.name,
    'url': url,
    'others': others,
  };

  Media copyWith({
    String? url,
    String? path,
    MediaType? type,
    AsList? others,
  }) => Media(
    path: path ?? this.path,
    type: type ?? this.type,
    url: url ?? this.url,
    others: others ?? this.others,
  );
}
