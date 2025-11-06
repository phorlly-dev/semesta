part of 'user_profile_model.dart';

class SocialMediaModel {
  final String? icon;
  final String? name;
  final String? link;

  const SocialMediaModel({this.icon, this.name, this.link});

  factory SocialMediaModel.fromMap(Map<String, dynamic> map) =>
      SocialMediaModel(icon: map['icon'], name: map['name'], link: map['link']);

  Map<String, dynamic> toMap() => {'icon': icon, 'name': name, 'link': link};
}
