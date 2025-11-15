import 'package:semesta/app/utils/json_helpers.dart';
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
    super.id,
    super.createdAt,
    super.updatedAt,
  });

  @override
  GroupModel copyWith({
    String? id,
    String? image,
    String? name,
    List<String>? members,
    bool? privacy,
  }) => GroupModel(
    id: id ?? this.id,
    image: image ?? this.image,
    name: name ?? this.name,
    privacy: privacy ?? this.privacy,
    members: members ?? this.members,
    createdAt: createdAt,
    updatedAt: DateTime.now(),
  );

  @override
  List<Object?> get props => [...super.props, image, name, members, privacy];

  factory GroupModel.fromMap(Map<String, dynamic> json) {
    final map = Model.convertJsonKeys(json, toCamelCase: true);
    return GroupModel(
      id: map['id'],
      image: map['image'] ?? '',
      name: map['name'],
      privacy: map['privacy'] ?? true,
      members: parseTo(map['members']),
      createdAt: Model.createOrUpdate(map),
      updatedAt: Model.createOrUpdate(map, false),
    );
  }

  @override
  Map<String, dynamic> toMap() {
    final data = {
      ...general,
      'image': image,
      'privacy': privacy,
      'members': members,
    };
    return Model.convertJsonKeys(data);
  }
}
