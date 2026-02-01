import 'package:semesta/public/utils/type_def.dart';
import 'package:semesta/app/models/model.dart';

enum Gender { female, male, other }

class Author extends Model<Author> {
  final String avatar;
  final String name;
  final Gender gender;
  final String? email;
  final String uname;
  final String bio;
  final String website;
  final String location;
  final String banner;

  final int follower;
  final int following;

  final DateTime? dob;
  final bool verified;

  const Author({
    super.id = '',
    this.avatar = '',
    this.name = '',
    this.gender = Gender.other,
    this.email,
    this.uname = '',
    this.dob,
    this.bio = '',
    this.website = '',
    this.location = '',
    this.banner = '',
    this.follower = 0,
    this.following = 0,
    this.verified = false,
    super.createdAt,
    super.updatedAt,
  });

  @override
  List<Object?> get props => [
    ...super.props,
    name,
    avatar,
    gender,
    email,
    uname,
    bio,
    website,
    location,
    banner,
    dob,
    verified,
    follower,
    following,
  ];

  factory Author.from(AsMap json) {
    final map = Model.convertJsonKeys(json, true);
    return Author(
      id: map['id'],
      name: map['name'],
      avatar: map['avatar'],
      dob: Model.toDateTime(map['dob']),
      gender: Gender.values.firstWhere(
        (e) => e.name == map['gender'],
        orElse: () => Gender.other,
      ),
      follower: map['follower'] ?? 0,
      following: map['following'] ?? 0,
      email: map['email'],
      banner: map['banner'],
      bio: map['bio'],
      verified: map['verified'] ?? false,
      location: map['location'],
      uname: map['uname'],
      website: map['website'],
      createdAt: Model.createOrUpdate(map),
      updatedAt: Model.createOrUpdate(map, false),
    );
  }

  @override
  AsMap to() => Model.convertJsonKeys({
    ...general,
    'name': name.trim(),
    'avatar': avatar,
    'gender': gender.name,
    'dob': Model.toEpoch(dob),
    'email': email?.trim(),
    'bio': bio,
    'banner': banner,
    'follower': follower,
    'following': following,
    'verified': verified,
    'location': location,
    'uname': uname.trim().toLowerCase(),
    'website': website,
  });

  @override
  Author copy({
    String? name,
    String? id,
    String? avatar,
    DateTime? dob,
    Gender? gender,
    String? email,
    String? banner,
    String? bio,
    int? follower,
    int? following,
    bool? verified,
    String? location,
    String? uname,
    String? website,
    DateTime? createdAt,
  }) => Author(
    id: id ?? this.id,
    name: name ?? this.name,
    avatar: avatar ?? this.avatar,
    dob: dob ?? this.dob,
    gender: gender ?? this.gender,
    email: email ?? this.email,
    banner: banner ?? this.banner,
    bio: bio ?? this.bio,
    follower: follower ?? this.follower,
    following: following ?? this.following,
    verified: verified ?? this.verified,
    location: location ?? this.location,
    uname: uname ?? this.uname,
    website: website ?? this.website,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: DateTime.now(),
  );
}
