import 'package:semesta/app/utils/json_helpers.dart';
part 'education_model.dart';
part 'social_media_model.dart';

enum AccountType { personal, creator, business, page }

class UserProfileModel {
  final String? avatar;
  final bool verified;
  final String? cover;
  final int? likes;
  final int? followers;
  final List<String>? hobbies;
  final List<String>? topFriends;
  final String? hometown;
  final List<SocialMediaModel>? socialMedia;
  final String? bio;
  final AccountType type;
  final List<EducationModel>? educations;
  final bool guard;
  final String? pageType;
  final String? address;
  final String? website; // personal link
  final List<String>? work; // workplaces or job titles
  final List<String>? interests; // topics followed
  final String? relationship; // "single", "married", etc.

  const UserProfileModel({
    this.website,
    this.work,
    this.interests,
    this.relationship,
    this.avatar,
    this.verified = false,
    this.cover,
    this.likes,
    this.followers,
    this.hobbies,
    this.topFriends,
    this.hometown,
    this.socialMedia,
    this.bio,
    this.type = AccountType.personal,
    this.educations,
    this.guard = false,
    this.pageType,
    this.address,
  });

  factory UserProfileModel.fromMap(Map<String, dynamic> map) {
    return UserProfileModel(
      avatar: map['avatar'],
      verified: map['verified'] ?? false,
      cover: map['cover'],
      likes: map['likes'],
      followers: map['followers'],
      hobbies: List<String>.from(map['hobbies']),
      topFriends: List<String>.from(map['top_friends']),
      hometown: map['hometown'],
      socialMedia: parseJsonList<SocialMediaModel>(
        map['social_media'],
        SocialMediaModel.fromMap,
      ),
      bio: map['bio'],
      type: AccountType.values.firstWhere(
        (e) => e.name == map['type'],
        orElse: () => AccountType.personal,
      ),
      educations: parseJsonList<EducationModel>(
        map['educations'],
        EducationModel.fromMap,
      ),
      guard: map['guard'] ?? false,
      pageType: map['page_type'],
      address: map['address'],
      interests: List<String>.from(map['interests']),
      relationship: map['relationship'],
      website: map['website'],
      work: List<String>.from(map['work']),
    );
  }

  Map<String, dynamic> toMap() => {
    'avatar': avatar,
    'verified': verified,
    'cover': cover,
    'likes': likes,
    'followers': followers,
    'hobbies': hobbies ?? const [],
    "top_friends": topFriends ?? const [],
    'hometown': hometown,
    'social_media': socialMedia?.map((e) => e.toMap()).toList(),
    'bio': bio,
    'type': type.name,
    'educations': educations?.map((e) => e.toMap()).toList(),
    "guard": guard,
    "page_type": pageType,
    'address': address,
    'interests': interests ?? const [],
    'relationship': relationship,
    'website': website,
    'work': work ?? const [],
  };
}
