part of 'user_profile_model.dart';

class SocialMediaModel {
  final String? logo;
  final String? name;
  final String? link;

  const SocialMediaModel({this.logo, this.name, this.link});

  factory SocialMediaModel.fromMap(Map<String, dynamic> map) =>
      SocialMediaModel(logo: map['logo'], name: map['name'], link: map['link']);

  Map<String, dynamic> toMap() => {'logo': logo, 'name': name, 'link': link};
}
