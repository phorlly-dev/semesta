import 'package:semesta/app/utils/json_helpers.dart';
import 'package:semesta/core/models/model.dart';
import 'package:semesta/core/models/user_profile_model.dart';

enum Gender { female, male, other }

class UserModel extends Model<UserModel> {
  final String? avatar;
  final String? name;
  final DateTime? birthday;
  final Gender gender;
  final String? email;
  final List<String>? friends;
  final List<String>? requests;
  final List<String>? receiveds;
  final UserProfileModel? profile;
  final bool isOnline; // for status indicator
  final DateTime? lastActive; // last seen timestamp
  final String? locale; // e.g. "en_US", "id_ID"
  final String? token; // for push notifications

  const UserModel({
    this.isOnline = false,
    this.lastActive,
    this.locale,
    this.token,
    this.avatar,
    this.profile,
    this.name,
    this.birthday,
    this.gender = Gender.other,
    this.email,
    this.friends = const [],
    this.receiveds = const [],
    this.requests = const [],
    super.id,
    super.createdAt,
    super.updatedAt,
  });

  @override
  List<Object?> get props => [
    ...super.props,
    name,
    birthday,
    gender,
    email,
    friends,
    receiveds,
    requests,
    profile,
    isOnline,
    lastActive,
    locale,
    token,
    avatar,
  ];

  factory UserModel.fromMap(Map<String, dynamic> json) {
    final map = Model.convertJsonKeys(json, toCamelCase: true);
    return UserModel(
      id: map['id'],
      name: map['name'],
      avatar: map['avatar'],
      birthday: Model.toDateTime(map['birthday']),
      gender: Gender.values.firstWhere(
        (e) => e.name == map['gender'],
        orElse: () => Gender.other,
      ),
      email: map['email'],
      friends: parseTo(map['friends']),
      receiveds: parseTo(map['equests']),
      requests: parseTo(map['receiveds']),
      profile: safeParse<UserProfileModel>(
        map['profile'],
        UserProfileModel.fromMap,
      ),
      token: map['token'],
      isOnline: map['isOnline'],
      lastActive: map['lastActive'],
      locale: map['locale'],
      createdAt: Model.createOrUpdate(map),
      updatedAt: Model.createOrUpdate(map, false),
    );
  }

  @override
  Map<String, dynamic> toMap() {
    final data = {
      ...general,
      'name': name,
      'avatar': avatar,
      'birthday': Model.toEpoch(birthday),
      'gender': gender.name,
      'email': email,
      'friends': friends ?? const [],
      'requests': receiveds ?? const [],
      'receiveds': requests ?? const [],
      'profile': profile?.toMap(),
      'token': token,
      'isOnline': isOnline,
      'lastActive': lastActive,
      'locale': locale,
    };
    return Model.convertJsonKeys(data);
  }

  @override
  UserModel copyWith({
    String? name,
    String? avatar,
    DateTime? birthday,
    Gender? gender,
    String? email,
    List<String>? friends,
    List<String>? receiveds,
    List<String>? requests,
    UserProfileModel? profile,
    bool? isOnline,
    DateTime? lastActive,
    String? locale,
    String? token,
  }) => UserModel(
    id: id,
    name: name ?? this.name,
    avatar: avatar ?? this.avatar,
    birthday: birthday ?? this.birthday,
    gender: gender ?? this.gender,
    email: email ?? this.email,
    friends: friends ?? this.friends,
    receiveds: receiveds ?? this.receiveds,
    requests: requests ?? this.requests,
    profile: profile ?? this.profile,
    token: token ?? this.token,
    isOnline: isOnline ?? this.isOnline,
    lastActive: lastActive ?? this.lastActive,
    locale: locale ?? this.locale,
    createdAt: createdAt,
    updatedAt: DateTime.now(),
  );

  int get friendCount => friends?.length ?? 0;
}
