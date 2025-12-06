import 'package:get/get.dart';
import 'package:semesta/app/utils/type_def.dart';
import 'package:semesta/core/models/model.dart';
import 'package:semesta/core/models/user_action_model.dart';

enum Gender { female, male, other }

class UserModel extends Model<UserModel> {
  final String avatar;
  final String name;
  final Gender gender;
  final String? email;
  final String username;
  final String bio;
  final String website;
  final String location;
  final String banner;

  final int followeredCount;
  final int followingedCount;
  final int postedCount;
  final UserActionModel action;

  final DateTime? dob;
  final bool isVerified;

  const UserModel({
    super.id = '',
    this.avatar = '',
    this.name = '',
    this.gender = Gender.other,
    this.email,
    this.username = '',
    this.dob,
    this.bio = '',
    this.website = '',
    this.location = '',
    this.banner = '',
    this.postedCount = 0,
    this.followeredCount = 0,
    this.followingedCount = 0,
    this.isVerified = false,
    super.createdAt,
    super.updatedAt,
    this.action = const UserActionModel(),
  });

  @override
  List<Object?> get props => [
    ...super.props,
    name,
    avatar,
    gender,
    email,
    username,
    bio,
    website,
    location,
    banner,
    dob,
    isVerified,
    postedCount,
    followeredCount,
    followingedCount,
  ];

  factory UserModel.fromMap(AsMap json) {
    final map = Model.convertJsonKeys(json, true);
    return UserModel(
      id: map['id'],
      name: map['name'],
      avatar: map['avatar'],
      dob: Model.toDateTime(map['dob']),
      gender: Gender.values.firstWhere(
        (e) => e.name == map['gender'],
        orElse: () => Gender.other,
      ),
      postedCount: map['postedCount'] ?? 0,
      followeredCount: map['followeredCount'] ?? 0,
      followingedCount: map['followingedCount'] ?? 0,
      email: map['email'],
      banner: map['banner'],
      bio: map['bio'],
      isVerified: map['isVerified'] ?? false,
      location: map['location'],
      username: map['username'],
      website: map['website'],
      createdAt: Model.createOrUpdate(map),
      updatedAt: Model.createOrUpdate(map, false),
    );
  }

  @override
  AsMap toMap() {
    final data = {
      ...general,
      'name': name.trim(),
      'avatar': avatar,
      'gender': gender.name,
      'dob': Model.toEpoch(dob),
      'email': email?.trim(),
      'bio': bio,
      'banner': banner,
      'postedCount': postedCount,
      'followeredCount': followeredCount,
      'followingedCount': followingedCount,
      'isVerified': isVerified,
      'location': location,
      'username': username.trim().toLowerCase(),
      'website': website,
    };
    return Model.convertJsonKeys(data);
  }

  @override
  UserModel copyWith({
    String? name,
    String? id,
    String? avatar,
    DateTime? dob,
    Gender? gender,
    String? email,
    String? banner,
    String? bio,
    int? postedCount,
    int? followeredCount,
    int? followingedCount,
    UserActionModel? action,
    bool? isVerified,
    String? location,
    String? username,
    String? website,
    DateTime? createdAt,
  }) => UserModel(
    id: id ?? this.id,
    name: name ?? this.name,
    avatar: avatar ?? this.avatar,
    dob: dob ?? this.dob,
    gender: gender ?? this.gender,
    email: email ?? this.email,
    banner: banner ?? this.banner,
    bio: bio ?? this.bio,
    action: action ?? this.action,
    followeredCount: followeredCount ?? this.followeredCount,
    followingedCount: followingedCount ?? this.followingedCount,
    postedCount: postedCount ?? this.postedCount,
    isVerified: isVerified ?? this.isVerified,
    location: location ?? this.location,
    username: username ?? this.username,
    website: website ?? this.website,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: DateTime.now(),
  );

  RxBool isFollowing(String userId) => action.followings.contains(userId).obs;
}
