import 'package:semesta/app/functions/json_helpers.dart';
import 'package:semesta/app/utils/type_def.dart';
import 'package:semesta/core/models/model.dart';

class PostActionModel {
  final String postId;
  final AsList likedBy;
  final AsList viewedBy;
  final AsList savedBy;
  final AsList sharedBy;
  final AsList repliedBy;
  final AsList repostedBy;
  final AsList quotedBy;

  const PostActionModel({
    this.postId = '',
    this.likedBy = const [],
    this.viewedBy = const [],
    this.repostedBy = const [],
    this.savedBy = const [],
    this.sharedBy = const [],
    this.repliedBy = const [],
    this.quotedBy = const [],
  });

  factory PostActionModel.fromMap(AsMap json) {
    final map = Model.convertJsonKeys(json, true);
    return PostActionModel(
      postId: map['postId'],
      likedBy: parseToList(map['likedBy']),
      viewedBy: parseToList(map['viewedBy']),
      repostedBy: parseToList(map['repostedBy']),
      repliedBy: parseToList(map['repliedBy']),
      quotedBy: parseToList(map['quotedBy']),
      savedBy: parseToList(map['savedBy']),
      sharedBy: parseToList(map['sharedBy']),
    );
  }

  AsMap toMap() {
    final data = {
      'postId': postId,
      'likedBy': likedBy.toList(),
      'viewedBy': viewedBy.toList(),
      'repostedBy': repostedBy.toList(),
      'repliedBy': repliedBy.toList(),
      'quotedBy': quotedBy.toList(),
      'savedBy': savedBy.toList(),
      'sharedBy': sharedBy.toList(),
    };
    return Model.convertJsonKeys(data);
  }

  PostActionModel copyWith({
    String? postId,
    AsList? likedBy,
    AsList? viewedBy,
    AsList? savedBy,
    AsList? sharedBy,
    AsList? repliedBy,
    AsList? repostedBy,
    AsList? quotedBy,
    DateTime? createdAt,
  }) => PostActionModel(
    postId: postId ?? this.postId,
    likedBy: likedBy ?? this.likedBy,
    viewedBy: viewedBy ?? this.viewedBy,
    repostedBy: repostedBy ?? this.repostedBy,
    repliedBy: repliedBy ?? this.repliedBy,
    quotedBy: quotedBy ?? this.quotedBy,
    savedBy: savedBy ?? this.savedBy,
    sharedBy: sharedBy ?? this.sharedBy,
  );
}
