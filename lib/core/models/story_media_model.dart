class StoryMediaModel {
  final String url;
  final String type; // 'image' | 'video'
  final String? thumbnail;
  final Duration? duration; // only for video

  const StoryMediaModel({
    required this.url,
    required this.type,
    this.thumbnail,
    this.duration,
  });

  factory StoryMediaModel.fromMap(Map<String, dynamic> map) => StoryMediaModel(
    url: map['url'],
    type: map['type'],
    thumbnail: map['thumbnail'],
    duration: map['duration'] != null
        ? Duration(milliseconds: map['duration'])
        : null,
  );

  Map<String, dynamic> toMap() => {
    'url': url,
    'type': type,
    'thumbnail': thumbnail,
    'duration': duration?.inMilliseconds,
  };
}
