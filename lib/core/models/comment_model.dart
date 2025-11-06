import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:semesta/app/utils/json_helpers.dart';
import 'package:semesta/core/models/favorite_model.dart';
import 'package:semesta/core/models/model.dart';

enum CommentType { text, image, gif, mixed }

class CommentModel extends Model<CommentModel> {
  final String postId;
  final String userId;
  final CommentType type; // text, image, gif, mixed
  final String? text;
  final String? imageUrl;
  final String? gifUrl;
  final List<String>? mentions; // user IDs of mentioned people
  final List<String>? emojis; // store emoji unicode or shortcode
  final FavoriteModel? favorite;
  final List<String>? replyIds;

  const CommentModel({
    required this.postId,
    required this.userId,
    this.type = CommentType.text,
    this.text,
    this.imageUrl,
    this.gifUrl,
    this.mentions,
    this.emojis,
    this.favorite,
    this.replyIds,
    required super.id,
    super.createdAt,
    super.updatedAt,
  });

  @override
  CommentModel copyWith({
    String? postId,
    String? userId,
    CommentType? type,
    String? text,
    String? imageUrl,
    String? gifUrl,
    List<String>? mentions,
    List<String>? emojis,
    FavoriteModel? favorite,
    List<String>? replyIds,
  }) {
    return CommentModel(
      id: id,
      postId: postId ?? this.postId,
      userId: userId ?? this.userId,
      type: type ?? this.type,
      text: text ?? this.text,
      imageUrl: imageUrl ?? this.imageUrl,
      gifUrl: gifUrl ?? this.gifUrl,
      mentions: mentions ?? this.mentions,
      emojis: emojis ?? this.emojis,
      favorite: favorite ?? this.favorite,
      replyIds: replyIds ?? this.replyIds,
      createdAt: createdAt,
      updatedAt: Timestamp.now(),
    );
  }

  @override
  List<Object?> get props => [
    ...super.props,
    postId,
    userId,
    type,
    text,
    imageUrl,
    gifUrl,
    mentions,
    emojis,
    favorite,
    replyIds,
  ];

  factory CommentModel.fromMap(Map<String, dynamic> map) {
    return CommentModel(
      id: map['id'] ?? '',
      postId: map['post_id'] ?? '',
      userId: map['user_id'] ?? '',
      text: map['text'],
      type: CommentType.values.firstWhere(
        (e) => e.name == map['type'],
        orElse: () => CommentType.text,
      ),
      imageUrl: map['image_url'],
      gifUrl: map['gif_url'],
      mentions: List<String>.from(map['mentions'] ?? []),
      emojis: List<String>.from(map['emojis'] ?? []),
      favorite: safeParse<FavoriteModel>(
        map['favorite'],
        FavoriteModel.fromMap,
      ),
      replyIds: List<String>.from(map['reply_ids'] ?? []),
      createdAt: map['created_at'] ?? Timestamp.now(),
      updatedAt: map['updated_at'] ?? Timestamp.now(),
    );
  }

  @override
  Map<String, dynamic> toMap() => {
    'id': id,
    'postId': postId,
    'userId': userId,
    'type': type.name,
    'text': text,
    'image_url': imageUrl,
    'gif_url': gifUrl,
    'mentions': mentions,
    'emojis': emojis,
    'favorite': favorite?.toMap(),
    'reply_ids': replyIds,
    'created_at': createdAt ?? Timestamp.now(),
    'updated_at': updatedAt ?? Timestamp.now(),
  };
}
