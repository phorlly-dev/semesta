import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:semesta/app/utils/json_helpers.dart';
import 'package:semesta/core/models/favorite_model.dart';
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
  final FavoriteModel? favorite;
  final int commentCount;
  final int shareCount;

  const PostModel({
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
    this.favorite,
    required super.id,
    super.createdAt,
    super.updatedAt,
  });

  @override
  PostModel copyWith({
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
    FavoriteModel? favorite,
    Map<String, dynamic>? linkPreview,
    List<String>? mentions,
    int? commentCount,
    int? shareCount,
  }) {
    return PostModel(
      id: id,
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
      favorite: favorite ?? this.favorite,
      commentCount: commentCount ?? this.commentCount,
      shareCount: shareCount ?? this.shareCount,
      linkPreview: linkPreview ?? linkPreview,
      mentions: mentions ?? mentions,
      createdAt: createdAt,
      updatedAt: Timestamp.now(),
    );
  }

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
    favorite,
    type,
    mentions,
    linkPreview,
    sharedPostId,
  ];

  factory PostModel.fromMap(Map<String, dynamic> map) => PostModel(
    id: map['id'] ?? '',
    userId: map['user_id'] ?? '',
    eventId: map['event_id'],
    images: List<String>.from(map['images'] ?? []),
    videos: List<String>.from(map['videos'] ?? []),
    tags: List<String>.from(map['tags'] ?? []),
    commentCount: map['comment_count'] ?? 0,
    shareCount: map['share_count'] ?? 0,
    content: map['content'],
    location: map['location'],
    feeling: map['feeling'],
    type: map['type'] ?? 'post',
    favorite: castToMap<FavoriteModel>(map['favorite'], FavoriteModel.fromMap),
    linkPreview: Map<String, dynamic>.from(map['link_preview'] ?? []),
    mentions: List<String>.from(map['mentions'] ?? []),
    sharedPostId: map['shared_post_id'],
    visibility: map['visibility'] ?? 'public',
    createdAt: map['created_at'] ?? Timestamp.now(),
    updatedAt: map['updated_at'] ?? Timestamp.now(),
  );

  @override
  Map<String, dynamic> toMap() => {
    'id': id,
    'user_id': userId,
    'content': content,
    'images': images,
    'videos': videos,
    'type': type,
    'tags': tags,
    'location': location,
    'link_preview': linkPreview,
    'mentions': mentions,
    'shared_post_id': sharedPostId,
    'feeling': feeling,
    'visibility': visibility,
    'event_id': eventId,
    'favorite': favorite?.toMap(),
    'comment_count': commentCount,
    'share_count': shareCount,
    'created_at': createdAt ?? Timestamp.now(),
    'updated_at': updatedAt ?? Timestamp.now(),
  };
}
