import 'package:semesta/app/models/media.dart';
import 'package:semesta/public/extensions/json_extension.dart';
import 'package:semesta/public/helpers/generic_helper.dart';
import 'package:semesta/public/utils/type_def.dart';
import 'package:semesta/app/models/model.dart';

enum Gender { other, female, male }

class Author extends IModel<Author> {
  final Gender gender;
  final String email;
  final String uname;

  final String bio;
  final String website;
  final String location;
  final Media media;

  final int followers;
  final int following;

  final DateTime birthdate;
  final bool edited, removed, verified;

  Author({
    super.id,
    super.name = '',
    this.email = '',
    this.uname = '',
    this.bio = '',
    this.website = '',
    this.location = '',
    this.followers = 0,
    this.following = 0,
    this.edited = false,
    this.removed = false,
    this.verified = false,
    this.gender = Gender.other,
    this.media = const Media(),
    super.createdAt,
    super.updatedAt,
    DateTime? birthdate,
  }) : birthdate = birthdate ?? now.add(const Duration(days: 365 * 16));

  @override
  List<Object?> get props => [
    ...super.props,
    gender,
    email,
    uname,
    bio,
    website,
    location,
    media,
    birthdate,
    verified,
    followers,
    following,
    media,
    edited,
    removed,
  ];

  factory Author.fromState(AsMap json) => Author(
    id: json.id,
    name: json.name,
    birthdate: json.asDate('birthdate'),
    followers: json.asInt('followers'),
    following: json.asInt('following'),
    email: json.asText('email'),
    bio: json.asText('bio'),
    verified: json.asBool('verified'),
    edited: json.asBool('edited'),
    removed: json.asBool('removed'),
    location: json.asText('location'),
    uname: json.asText('uname'),
    website: json.asText('website'),
    createdAt: json.created,
    updatedAt: json.updated,
    media: json.asJsons('media', Media.fromState),
    gender: json.asEnum('gender', Gender.values),
  );

  @override
  AsMap toPayload() => {
    ...general,
    'bio': bio.trim(),
    'name': name.trim(),
    'email': email.trim(),
    'uname': uname.trim(),
    'location': location.trim(),
    'media': media.toPayload(),
    'website': website,
    'followers': followers,
    'verified': verified,
    'removed': removed,
    'edited': edited,
    'gender': gender.name,
    'following': following,
    'birthdate': toEpoch(birthdate),
  };

  @override
  Author copyWith({
    String? id,
    String? name,
    DateTime? birthdate,
    Gender? gender,
    String? email,
    Media? media,
    String? bio,
    int? followers,
    int? following,
    bool? verified,
    bool? edited,
    bool? removed,
    String? location,
    String? uname,
    String? website,
    DateTime? createdAt,
  }) => Author(
    id: id ?? this.id,
    name: name ?? this.name,
    birthdate: birthdate ?? this.birthdate,
    gender: gender ?? this.gender,
    email: email ?? this.email,
    media: media ?? this.media,
    bio: bio ?? this.bio,
    followers: followers ?? this.followers,
    following: following ?? this.following,
    verified: verified ?? this.verified,
    edited: edited ?? this.edited,
    removed: removed ?? this.removed,
    location: location ?? this.location,
    uname: uname ?? this.uname,
    website: website ?? this.website,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: now,
  );
}
