import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:semesta/app/utils/json_helpers.dart';
import 'package:semesta/core/models/model.dart';
import 'package:semesta/core/models/user_profile_model.dart';

enum Gender { male, female, other, preferNotToSay }

class UserModel extends Model<UserModel> {
  final String fullName;
  final DateTime birthDay;
  final Gender gender;
  final String email;
  final String? password;
  final List<String>? friends;
  final List<String>? sentRequests;
  final List<String>? receivedRequests;
  final UserProfileModel? profile;
  final bool isOnline; // for status indicator
  final DateTime? lastActive; // last seen timestamp
  final String? locale; // e.g. "en_US", "id_ID"
  final String? fcmToken; // for push notifications

  const UserModel({
    this.isOnline = false,
    this.lastActive,
    this.locale,
    this.fcmToken,
    this.profile,
    required this.fullName,
    required this.birthDay,
    required this.gender,
    required this.email,
    this.password,
    this.friends = const [],
    this.sentRequests = const [],
    this.receivedRequests = const [],
    required super.id,
    super.createdAt,
    super.updatedAt,
  });

  @override
  List<Object?> get props => [
    ...super.props,
    fullName,
    birthDay,
    gender,
    email,
    password,
    friends,
    sentRequests,
    receivedRequests,
    profile,
    isOnline,
    lastActive,
    locale,
    fcmToken,
  ];

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'],
      fullName: map['full_name'],
      birthDay: DateTime.fromMillisecondsSinceEpoch(map['birth_day'] as int),
      gender: Gender.values.firstWhere(
        (e) => e.name == map['gender'],
        orElse: () => Gender.preferNotToSay,
      ),
      email: map['email'],
      password: map['password'],
      friends: List<String>.from((map['friends'] ?? [])),
      sentRequests: List<String>.from((map['sent_requests'] ?? [])),
      receivedRequests: List<String>.from((map['received_requests'] ?? [])),
      profile: safeParse<UserProfileModel>(
        map['profile'],
        UserProfileModel.fromMap,
      ),
      fcmToken: map['fcm_token'],
      isOnline: map['is_online'],
      lastActive: map['last_active'],
      locale: map['locale'],
      createdAt: map['created_at'] ?? Timestamp.now(),
      updatedAt: map['updated_at'] ?? Timestamp.now(),
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'full_name': fullName,
      'birth_day': birthDay.millisecondsSinceEpoch,
      'gender': gender.name,
      'email': email,
      'password': password,
      'friends': friends ?? const [],
      'sent_requests': sentRequests ?? const [],
      'received_requests': receivedRequests ?? const [],
      'profile': profile?.toMap(),
      'fcm_token': fcmToken,
      'is_online': isOnline,
      'last_active': lastActive,
      'locale': locale,
      'created_at': createdAt ?? Timestamp.now(),
      'updated_at': updatedAt ?? Timestamp.now(),
    };
  }

  @override
  UserModel copyWith({
    String? fullName,
    DateTime? birthDay,
    Gender? gender,
    String? email,
    String? password,
    List<String>? friends,
    List<String>? sentRequests,
    List<String>? receivedRequests,
    UserProfileModel? profile,
    bool? isOnline,
    DateTime? lastActive,
    String? locale,
    String? fcmToken,
  }) {
    return UserModel(
      id: id,
      fullName: fullName ?? this.fullName,
      birthDay: birthDay ?? this.birthDay,
      gender: gender ?? this.gender,
      email: email ?? this.email,
      password: password ?? this.password,
      friends: friends ?? this.friends,
      sentRequests: sentRequests ?? this.sentRequests,
      receivedRequests: receivedRequests ?? this.receivedRequests,
      profile: profile ?? this.profile,
      fcmToken: fcmToken ?? this.fcmToken,
      isOnline: isOnline ?? this.isOnline,
      lastActive: lastActive ?? this.lastActive,
      locale: locale ?? this.locale,
      createdAt: createdAt,
      updatedAt: Timestamp.now(),
    );
  }

  int get friendCount => friends?.length ?? 0;
}
