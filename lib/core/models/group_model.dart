import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:semesta/core/models/model.dart';

class GroupModel extends Model<GroupModel> {
  final String? image;
  final String name;
  final bool privacy;
  final List<String>? members;

  const GroupModel({
    this.privacy = true,
    this.image,
    required this.name,
    required this.members,
    required super.id,
    super.createdAt,
    super.updatedAt,
  });

  @override
  GroupModel copyWith({
    String? image,
    String? name,
    List<String>? members,
    bool? privacy,
  }) {
    return GroupModel(
      id: id,
      image: image ?? this.image,
      name: name ?? this.name,
      privacy: privacy ?? this.privacy,
      members: members ?? this.members,
      createdAt: createdAt,
      updatedAt: Timestamp.now(),
    );
  }

  @override
  List<Object?> get props => [...super.props, image, name, members, privacy];

  factory GroupModel.fromMap(Map<String, dynamic> map) => GroupModel(
    id: map['id'],
    image: map['image'] ?? '',
    name: map['name'],
    privacy: map['privacy'] ?? true,
    members: List<String>.from(map['members'] ?? []),
    createdAt: map['created_at'] ?? Timestamp.now(),
    updatedAt: map['updated_at'] ?? Timestamp.now(),
  );

  @override
  Map<String, dynamic> toMap() => {
    'id': id,
    'image': image,
    'privacy': privacy,
    'members': members,
    'created_at': createdAt ?? Timestamp.now(),
    'updated_at': updatedAt ?? Timestamp.now(),
  };
}
