import 'package:semesta/app/utils/json_helpers.dart';
import 'package:semesta/core/models/reaction_model.dart';
import 'package:semesta/core/models/model.dart';

class PostModel extends Model<PostModel> {
  final String userId;
  final String? content;
  final String type;
  final List<String>? images;
  final List<String>? videos;
  final List<String>? tags; // user IDs of tagged friends
  final String? location;
  final String? feeling; // e.g. "😊 Happy", "🎉 Excited", "Sad"
  final String visibility; // "public", "friends", or "only_me"
  final List<String>? mentions; // optional, user IDs from text
  final Map<String, dynamic>? linkPreview; // optional metadata (title, image)
  final String? eventId; // optional
  final String? sharedPostId; // optional
  final ReactionModel? reaction;
  final int commentCount;
  final int shareCount;
  final int viewCount;

  const PostModel({
    this.viewCount = 0,
    this.mentions,
    this.linkPreview,
    this.sharedPostId,
    this.type = 'post',
    this.content,
    this.tags,
    this.location,
    this.feeling,
    this.visibility = 'public',
    this.eventId,
    this.commentCount = 0,
    this.shareCount = 0,
    required this.userId,
    this.images,
    this.videos,
    this.reaction,
    super.id,
    super.createdAt,
    super.updatedAt,
  });

  @override
  PostModel copyWith({
    String? id,
    String? userId,
    String? content,
    String? type,
    String? sharedPostId,
    List<String>? images,
    List<String>? videos,
    List<String>? tags,
    String? location,
    String? feeling,
    String? visibility,
    String? eventId,
    ReactionModel? reaction,
    Map<String, dynamic>? linkPreview,
    List<String>? mentions,
    int? commentCount,
    int? shareCount,
    int? viewCount,
  }) => PostModel(
    id: id ?? this.id,
    userId: userId ?? this.userId,
    content: content ?? this.content,
    type: type ?? this.type,
    sharedPostId: sharedPostId ?? this.sharedPostId,
    images: images ?? this.images,
    videos: videos ?? this.videos,
    tags: tags ?? this.tags,
    location: location ?? this.location,
    feeling: feeling ?? this.feeling,
    visibility: visibility ?? this.visibility,
    eventId: eventId ?? this.eventId,
    reaction: reaction ?? this.reaction,
    commentCount: commentCount ?? this.commentCount,
    shareCount: shareCount ?? this.shareCount,
    viewCount: viewCount ?? this.viewCount,
    linkPreview: linkPreview ?? linkPreview,
    mentions: mentions ?? mentions,
    createdAt: createdAt,
    updatedAt: DateTime.now(),
  );

  @override
  List<Object?> get props => [
    ...super.props,
    content,
    tags,
    location,
    feeling,
    visibility,
    eventId,
    commentCount,
    shareCount,
    userId,
    images,
    videos,
    reaction,
    type,
    mentions,
    linkPreview,
    sharedPostId,
    viewCount,
  ];

  factory PostModel.fromMap(Map<String, dynamic> json) {
    final map = Model.convertJsonKeys(json, toCamelCase: true);
    return PostModel(
      id: map['id'] ?? '',
      userId: map['userId'] ?? '',
      eventId: map['eventId'],
      images: parseTo(map['images']),
      videos: parseTo(map['videos']),
      tags: parseTo(map['tags']),
      commentCount: map['commentCount'] ?? 0,
      viewCount: map['viewCount'] ?? 0,
      shareCount: map['shareCount'] ?? 0,
      content: map['content'],
      location: map['location'],
      feeling: map['feeling'],
      type: map['type'] ?? 'post',
      reaction: castToMap<ReactionModel>(
        map['reaction'],
        ReactionModel.fromMap,
      ),
      linkPreview: parseTo(map['linkPreview'], false),
      mentions: parseTo(map['mentions']),
      sharedPostId: map['sharedPostId'],
      visibility: map['visibility'] ?? 'public',
      createdAt: Model.createOrUpdate(map),
      updatedAt: Model.createOrUpdate(map, false),
    );
  }

  @override
  Map<String, dynamic> toMap() => {
    ...general,
    'userId': userId,
    'content': content,
    'images': images ?? const [],
    'videos': videos ?? const [],
    'type': type,
    'tags': tags ?? const [],
    'location': location,
    'linkPreview': linkPreview ?? const [],
    'mentions': mentions ?? const [],
    'sharedPostId': sharedPostId,
    'feeling': feeling,
    'visibility': visibility,
    'eventId': eventId,
    'reaction': reaction?.toMap(),
    'commentCount': commentCount,
    'viewCount': viewCount,
    'shareCount': shareCount,
  };
}
