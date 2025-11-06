part of 'user_profile_model.dart';

class EducationModel {
  final String? majors;
  final String? school;

  const EducationModel({this.majors, this.school});

  factory EducationModel.fromMap(Map<String, dynamic> map) =>
      EducationModel(majors: map['majors'], school: map['school']);

  Map<String, dynamic> toMap() => {'majors': majors, 'school': school};
}
