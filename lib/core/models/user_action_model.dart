import 'package:semesta/app/functions/json_helpers.dart';
import 'package:semesta/app/utils/type_def.dart';
import 'package:semesta/core/models/model.dart';

class UserActionModel {
  final String userId;
  final AsList followers;
  final AsList followings;
  final AsList likedPosts;
  final AsList viewedPosts;
  final AsList repostedPosts;
  final AsList quotedPosts;
  final AsList repliedPosts;
  final AsList savedPosts;
  final AsList sharedPosts;

  const UserActionModel({
    this.userId = '',
    this.followers = const [],
    this.followings = const [],
    this.likedPosts = const [],
    this.viewedPosts = const [],
    this.repostedPosts = const [],
    this.savedPosts = const [],
    this.sharedPosts = const [],
    this.quotedPosts = const [],
    this.repliedPosts = const [],
  });

  factory UserActionModel.fromMap(AsMap json) {
    final map = Model.convertJsonKeys(json, true);
    return UserActionModel(
      userId: map['userId'],
      followers: parseToList(map['followers']),
      followings: parseToList(map['followings']),
      likedPosts: parseToList(map['likedPosts']),
      savedPosts: parseToList(map['savedPosts']),
      viewedPosts: parseToList(map['viewedPosts']),
      repostedPosts: parseToList(map['repostedPosts']),
      quotedPosts: parseToList(map['quotedPosts']),
      repliedPosts: parseToList(map['repliedPosts']),
      sharedPosts: parseToList(map['sharedPosts']),
    );
  }

  AsMap toMap() {
    final data = {
      'userId': userId,
      'followers': followers.toList(),
      'followings': followings.toList(),
      'likedPosts': likedPosts.toList(),
      'savedPosts': savedPosts.toList(),
      'viewedPosts': viewedPosts.toList(),
      'repostedPosts': repostedPosts.toList(),
      'quotedPost': quotedPosts.toList(),
      'repliedPost': repliedPosts.toList(),
      'sharedPosts': sharedPosts.toList(),
    };
    return Model.convertJsonKeys(data);
  }

  UserActionModel copyWith({
    String? userId,
    AsList? followers,
    AsList? followings,
    AsList? likedPosts,
    AsList? viewedPosts,
    AsList? repostedPosts,
    AsList? quotedPosts,
    AsList? repliedPosts,
    AsList? savedPosts,
    AsList? sharedPosts,
    DateTime? createdAt,
  }) => UserActionModel(
    userId: userId ?? this.userId,
    followers: followers ?? this.followers,
    followings: followings ?? this.followings,
    likedPosts: likedPosts ?? this.likedPosts,
    savedPosts: savedPosts ?? this.savedPosts,
    viewedPosts: viewedPosts ?? this.viewedPosts,
    repostedPosts: repostedPosts ?? this.repostedPosts,
    quotedPosts: quotedPosts ?? this.quotedPosts,
    repliedPosts: repliedPosts ?? this.repliedPosts,
    sharedPosts: sharedPosts ?? this.sharedPosts,
  );
}
