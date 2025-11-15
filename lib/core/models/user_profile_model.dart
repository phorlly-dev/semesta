import 'package:semesta/app/utils/json_helpers.dart';
import 'package:semesta/core/models/model.dart';
part 'education_model.dart';
part 'social_media_model.dart';

enum AccountType { personal, creator, business, page }

class UserProfileModel {
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

  factory UserProfileModel.fromMap(Map<String, dynamic> json) {
    final map = Model.convertJsonKeys(json);
    return UserProfileModel(
      verified: map['verified'] ?? false,
      cover: map['cover'],
      likes: map['likes'],
      followers: map['followers'],
      hobbies: parseTo(map['hobbies']),
      topFriends: parseTo(map['topFriends']),
      hometown: map['hometown'],
      socialMedia: parseJsonList<SocialMediaModel>(
        map['socialMedia'],
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
      pageType: map['pageType'],
      address: map['address'],
      interests: parseTo(map['interests']),
      relationship: map['relationship'],
      website: map['website'],
      work: parseTo(map['work']),
    );
  }

  Map<String, dynamic> toMap() {
    final data = {
      'verified': verified,
      'cover': cover,
      'likes': likes,
      'followers': followers,
      'hobbies': hobbies ?? const [],
      "topFriends": topFriends ?? const [],
      'hometown': hometown,
      'socialMedia': socialMedia?.map((e) => e.toMap()).toList(),
      'bio': bio,
      'type': type.name,
      'educations': educations?.map((e) => e.toMap()).toList(),
      "guard": guard,
      "pageType": pageType,
      'address': address,
      'interests': interests ?? const [],
      'relationship': relationship,
      'website': website,
      'work': work ?? const [],
    };
    return Model.convertJsonKeys(data);
  }
}
