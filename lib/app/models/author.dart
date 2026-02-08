import 'package:semesta/public/extensions/string_extension.dart';
import 'package:semesta/public/functions/func_helper.dart';
import 'package:semesta/public/helpers/generic_helper.dart';
import 'package:semesta/public/utils/type_def.dart';
import 'package:semesta/app/models/model.dart';

enum Gender { female, male, other }

class Author extends IModel<Author> {
  final String avatar;
  final String name;
  final Gender gender;
  final String email;
  final String uname;
  final String bio;
  final String website;
  final String location;
  final String cover;

  final int followers;
  final int following;

  final bool verified;
  final DateTime birthdate;

  Author({
    super.id = '',
    this.avatar = '',
    this.name = '',
    this.gender = Gender.other,
    this.email = '',
    this.uname = '',
    this.bio = '',
    this.website = '',
    this.location = '',
    this.cover = '',
    this.followers = 0,
    this.following = 0,
    this.verified = false,
    super.createdAt,
    super.updatedAt,
    DateTime? birthdate,
  }) : birthdate = birthdate ?? now.add(Duration(days: 365 * 16));

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
    cover,
    birthdate,
    verified,
    followers,
    following,
  ];

  factory Author.from(AsMap json) {
    final map = IModel.convert(json, true);
    return Author(
      id: map['id'],
      name: map['name'],
      avatar: map['avatar'],
      birthdate: IModel.toDateTime(map['birthdate']),
      gender: parseEnum(map['gender'], Gender.values, Gender.other),
      followers: map['followers'] ?? 0,
      following: map['following'] ?? 0,
      email: map['email'],
      cover: map['cover'],
      bio: map['bio'],
      verified: map['verified'] ?? false,
      location: map['location'],
      uname: map['uname'],
      website: map['website'],
      createdAt: IModel.make(map),
      updatedAt: IModel.make(map, true),
    );
  }

  @override
  AsMap to() => IModel.convert({
    ...general,
    'bio': bio.trim(),
    'name': name.trim(),
    'email': email.trim(),
    'uname': uname.trim(),
    'location': location.trim(),
    'cover': cover,
    'avatar': avatar,
    'website': website.normalizeUrl,
    'followers': followers,
    'verified': verified,
    'gender': gender.name,
    'following': following,
    'birthdate': IModel.toEpoch(birthdate),
  });

  @override
  Author copy({
    String? name,
    String? id,
    String? avatar,
    DateTime? birthdate,
    Gender? gender,
    String? email,
    String? cover,
    String? bio,
    int? followers,
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
    birthdate: birthdate ?? this.birthdate,
    gender: gender ?? this.gender,
    email: email ?? this.email,
    cover: cover ?? this.cover,
    bio: bio ?? this.bio,
    followers: followers ?? this.followers,
    following: following ?? this.following,
    verified: verified ?? this.verified,
    location: location ?? this.location,
    uname: uname ?? this.uname,
    website: website ?? this.website,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: now,
  );
}
