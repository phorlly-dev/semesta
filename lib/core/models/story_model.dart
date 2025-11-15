import 'package:semesta/app/utils/json_helpers.dart';
import 'package:semesta/core/models/reaction_model.dart';
import 'package:semesta/core/models/model.dart';
import 'package:semesta/core/models/story_media_model.dart';

class StoryModel extends Model<StoryModel> {
  final String userId;
  final String? title;
  final String? thumbnailUrl;
  final bool isPublic;
  final List<String>? visibleTo;
  final List<StoryMediaModel> media;
  final List<String> viewers;
  final List<ReactionModel>? reactions;
  final int viewsCount;
  final int reactionsCount;
  final int sharesCount;
  final DateTime? expiresAt;

  const StoryModel({
    required this.userId,
    required this.media,
    this.title,
    this.thumbnailUrl,
    this.isPublic = true,
    this.visibleTo,
    this.viewers = const [],
    this.reactions,
    this.viewsCount = 0,
    this.reactionsCount = 0,
    this.sharesCount = 0,
    this.expiresAt,
    super.id,
    super.createdAt,
    super.updatedAt,
  });

  @override
  StoryModel copyWith({
    String? id,
    String? title,
    String? userId,
    String? thumbnailUrl,
    bool? isPublic,
    List<String>? visibleTo,
    List<StoryMediaModel>? media,
    List<String>? viewers,
    List<ReactionModel>? reactions,
    int? viewsCount,
    int? reactionsCount,
    int? sharesCount,
    DateTime? expiresAt,
  }) => StoryModel(
    id: id ?? this.id,
    userId: userId ?? this.userId,
    title: title ?? this.title,
    thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
    isPublic: isPublic ?? this.isPublic,
    visibleTo: visibleTo ?? this.visibleTo,
    media: media ?? this.media,
    viewers: viewers ?? this.viewers,
    reactions: reactions ?? this.reactions,
    viewsCount: viewsCount ?? this.viewsCount,
    reactionsCount: reactionsCount ?? this.reactionsCount,
    sharesCount: sharesCount ?? this.sharesCount,
    expiresAt: expiresAt ?? this.expiresAt,
    createdAt: createdAt,
    updatedAt: DateTime.now(),
  );

  @override
  List<Object?> get props => [
    ...super.props,
    userId,
    media,
    title,
    thumbnailUrl,
    isPublic,
    visibleTo,
    viewers,
    reactions,
    viewsCount,
    reactionsCount,
    sharesCount,
    expiresAt,
  ];

  factory StoryModel.fromMap(Map<String, dynamic> json) {
    final map = Model.convertJsonKeys(json, toCamelCase: true);
    return StoryModel(
      id: map['id'],
      userId: map['userId'],
      title: map['title'],
      expiresAt: Model.toDateTime(map['expiresAt']),
      isPublic: map['isPublic'] ?? true,
      reactionsCount: map['reactionsCount'] ?? 0,
      sharesCount: map['sharesCount'] ?? 0,
      thumbnailUrl: map['thumbnailUrl'],
      viewsCount: map['viewsCount'] ?? 0,
      visibleTo: parseTo(map['visibleTo']),
      viewers: parseTo(map['viewers']),
      reactions: parseJsonList<ReactionModel>(
        map['reactions'],
        ReactionModel.fromMap,
      ),
      media: parseJsonList<StoryMediaModel>(
        map['media'],
        StoryMediaModel.fromMap,
      ),
      createdAt: Model.createOrUpdate(map),
      updatedAt: Model.createOrUpdate(map, false),
    );
  }

  @override
  Map<String, dynamic> toMap() {
    final data = {
      ...general,
      'userId': userId,
      'expiresAt': Model.toEpoch(expiresAt),
      'isPublic': isPublic,
      'reactionsCount': reactionsCount,
      'sharesCount': sharesCount,
      'thumbnailUrl': thumbnailUrl,
      'viewsCount': viewsCount,
      'viewers': viewers,
      'reactions': reactions?.map((e) => e.toMap()).toList(),
      'media': media.map((e) => e.toMap()).toList(),
      'visibleTo': visibleTo ?? const [],
      'title': title,
    };
    return Model.convertJsonKeys(data);
  }
}

class Story {
  final String id;
  final String userName;
  final String userAvatar;
  final List<String>? images, videos;
  final bool isUser;

  Story({
    this.images,
    this.videos,
    required this.id,
    required this.userName,
    required this.userAvatar,
    this.isUser = false,
  });
}

final sampleStories = [
  Story(
    id: '1',
    userName: 'You',
    userAvatar: 'https://i.pravatar.cc/150?img=3',
    images: ['https://picsum.photos/200/300'],
    isUser: true,
    videos: [
      'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4',
      // 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerJoyrides.mp4',
    ],
  ),
  Story(
    id: '2',
    userName: 'Bente Othman',
    userAvatar: 'https://i.pravatar.cc/150?img=2',
    images: ['https://picsum.photos/200/301'],
    videos: [
      'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4',
      // 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerJoyrides.mp4',
    ],
  ),
  Story(
    id: '3',
    userName: 'Jordan Jones',
    userAvatar: 'https://i.pravatar.cc/150?img=1',
    images: ['https://picsum.photos/200/302'],
    videos: [
      'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4',
      // 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerJoyrides.mp4',
    ],
  ),
];

 // shareWith: public, friends, friends-of-friends, private
 