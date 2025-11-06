import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:semesta/core/models/favorite_model.dart';
import 'package:semesta/core/models/model.dart';

class StoryModel extends Model<StoryModel> {
  final String userId;
  final List<String>? images, videos, musics, plays;
  final String? shareWith;
  final String? title;
  final List<FavoriteModel>? favorites;

  const StoryModel({
    required this.userId,
    this.images,
    this.videos,
    this.musics,
    this.shareWith,
    this.plays,
    this.title,
    this.favorites,
    required super.id,
    super.createdAt,
    super.updatedAt,
  });

  @override
  StoryModel copyWith({
    String? userId,
    List<String>? images,
    List<String>? videos,
    List<String>? musics,
    List<String>? plays,
    List<FavoriteModel>? favorites,
    String? shareWith,
    String? title,
  }) {
    return StoryModel(
      id: id,
      userId: userId ?? this.userId,
      images: images ?? this.images,
      videos: videos ?? this.videos,
      musics: musics ?? this.musics,
      favorites: favorites ?? this.favorites,
      plays: plays ?? this.plays,
      shareWith: shareWith ?? this.shareWith,
      title: title ?? this.title,
      createdAt: createdAt,
      updatedAt: Timestamp.now(),
    );
  }

  @override
  List<Object?> get props => [
    ...super.props,
    userId,
    images,
    videos,
    musics,
    shareWith,
    title,
    plays,
    favorites,
  ];

  factory StoryModel.fromMap(Map<String, dynamic> map) => StoryModel(
    userId: map['user_id'],
    images: List<String>.from(map['images'] ?? []),
    videos: List<String>.from(map['videos'] ?? []),
    musics: List<String>.from(map['musics'] ?? []),
    shareWith: map['share_with'] ?? '',
    title: map['title'],
    id: map['id'],
    createdAt: map['created_at'] ?? Timestamp.now(),
    updatedAt: map['updated_at'] ?? Timestamp.now(),
  );

  @override
  Map<String, dynamic> toMap() => {
    'user_id': userId,
    'images': images ?? [],
    'videos': videos ?? [],
    'musics': musics ?? [],
    'plays': plays ?? [],
    'favorites': favorites ?? [],
    'share_with': shareWith ?? '',
    'title': title,
    'created_at': createdAt ?? Timestamp.now(),
    'updated_at': updatedAt ?? Timestamp.now(),
  };
}

 // shareWith: public, friends, friends-of-friends, private