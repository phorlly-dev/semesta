import 'package:semesta/app/functions/json_helpers.dart';
import 'package:semesta/app/utils/type_def.dart';
import 'package:semesta/core/models/media_model.dart';
import 'package:semesta/core/models/model.dart';
import 'package:semesta/core/models/post_action_model.dart';

enum PostVisibility { everyone, verified, following, mentioned }

enum PostType { post, reply, quote }

class PostModel extends Model<PostModel> {
  final String userId;
  final String displayName;
  final String username;
  final String userAvatar;

  final String content;
  final String location;
  final List<MediaModel> media;

  final PostType type;
  final String parentId;
  final PostVisibility visibility;

  final int likedCount;
  final int viewedCount;
  final int reliedCount;
  final int repostedCount;
  final int savedCount;
  final int sharedCount;

  final bool isEdited;
  final bool isDeleted;
  final PostActionModel action;

  final AsList hashtags;
  final AsList mentions;

  const PostModel({
    super.id = '',
    this.userId = '',
    this.displayName = '',
    this.username = '',
    this.userAvatar = '',
    this.content = '',
    this.media = const [],
    this.location = '',
    this.visibility = PostVisibility.everyone,
    this.hashtags = const [],
    this.mentions = const [],
    this.type = PostType.post,
    this.parentId = '',
    this.isEdited = false,
    this.isDeleted = false,
    this.likedCount = 0,
    this.viewedCount = 0,
    this.reliedCount = 0,
    this.repostedCount = 0,
    this.savedCount = 0,
    this.sharedCount = 0,
    super.createdAt,
    super.updatedAt,
    this.action = const PostActionModel(),
  });

  @override
  PostModel copyWith({
    String? id,
    String? userId,
    String? displayName,
    String? username,
    String? userAvatar,
    String? content,
    List<MediaModel>? media,
    String? location,
    PostVisibility? visibility,
    int? likedCount,
    int? viewedCount,
    int? reliedCount,
    int? repostedCount,
    int? savedCount,
    int? sharedCount,
    PostType? type,
    bool? isEdited,
    bool? isDeleted,
    String? parentId,
    PostActionModel? action,
    AsList? hashtags,
    AsList? mentions,
    DateTime? createdAt,
  }) => PostModel(
    id: id ?? this.id,
    userId: userId ?? this.userId,
    content: content ?? this.content,
    parentId: parentId ?? this.parentId,
    hashtags: hashtags ?? this.hashtags,
    media: media ?? this.media,
    isEdited: isEdited ?? this.isEdited,
    isDeleted: isDeleted ?? this.isDeleted,
    location: location ?? this.location,
    userAvatar: userAvatar ?? this.userAvatar,
    displayName: displayName ?? this.displayName,
    username: username ?? this.username,
    visibility: visibility ?? this.visibility,
    type: type ?? this.type,
    action: action ?? this.action,
    likedCount: likedCount ?? this.likedCount,
    reliedCount: reliedCount ?? this.reliedCount,
    repostedCount: repostedCount ?? this.repostedCount,
    savedCount: savedCount ?? this.savedCount,
    sharedCount: sharedCount ?? this.sharedCount,
    viewedCount: viewedCount ?? this.viewedCount,
    mentions: mentions ?? this.mentions,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: DateTime.now(),
  );

  @override
  List<Object?> get props => [
    ...super.props,
    userId,
    displayName,
    username,
    userAvatar,
    isDeleted,
    content,
    media,
    location,
    visibility,
    isEdited,
    parentId,
    hashtags,
    mentions,
    type,
    likedCount,
    viewedCount,
    reliedCount,
    repostedCount,
    savedCount,
    sharedCount,
  ];

  factory PostModel.fromMap(AsMap json, {PostActionModel? action}) {
    final map = Model.convertJsonKeys(json, true);
    return PostModel(
      id: map['id'],
      userId: map['userId'],
      content: map['content'],
      location: map['location'],
      username: map['username'],
      parentId: map['parentId'],
      userAvatar: map['userAvatar'],
      displayName: map['displayName'],
      isEdited: map['isEdited'] ?? false,
      isDeleted: map['isDeleted'] ?? false,
      likedCount: map['likedCount'] ?? 0,
      reliedCount: map['reliedCount'] ?? 0,
      repostedCount: map['repostedCount'] ?? 0,
      savedCount: map['savedCount'] ?? 0,
      sharedCount: map['sharedCount'] ?? 0,
      viewedCount: map['viewedCount'] ?? 0,
      hashtags: parseToList(map['hashtags']),
      mentions: parseToList(map['mentions']),
      media: parseJsonList<MediaModel>(map['media'], MediaModel.fromMap),
      visibility: PostVisibility.values.firstWhere(
        (e) => e.name == map['visibility'],
        orElse: () => PostVisibility.everyone,
      ),
      type: PostType.values.firstWhere(
        (e) => e.name == map['type'],
        orElse: () => PostType.post,
      ),
      action: action ?? PostActionModel(),
      createdAt: Model.createOrUpdate(map),
      updatedAt: Model.createOrUpdate(map, false),
    );
  }

  @override
  AsMap toMap() {
    final data = {
      ...general,
      'content': content,
      'userId': userId,
      'isEdited': isEdited,
      'isDeleted': isDeleted,
      'location': location,
      'displayName': displayName,
      'username': username,
      'parentId': parentId,
      'userAvatar': userAvatar,
      'hashtags': hashtags.toList(),
      'mentions': mentions.toList(),
      'media': media.map((e) => e.toMap()),
      'type': type.name,
      'likedCount': likedCount,
      'reliedCount': reliedCount,
      'repostedCount': repostedCount,
      'savedCount': savedCount,
      'sharedCount': sharedCount,
      'viewedCount': viewedCount,
      'visibility': visibility.name,
    };
    return Model.convertJsonKeys(data);
  }

  bool isLiked(String uid) => action.likedBy.contains(uid);
  bool isSaved(String uid) => action.savedBy.contains(uid);
  bool isReposted(String uid) => action.repostedBy.contains(uid);
}
