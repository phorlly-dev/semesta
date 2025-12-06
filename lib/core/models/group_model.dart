import 'package:semesta/app/functions/json_helpers.dart';
import 'package:semesta/app/utils/type_def.dart';
import 'package:semesta/core/models/model.dart';

class GroupModel extends Model<GroupModel> {
  final String? logo;
  final String name;
  final String creatorId;
  final String? description;
  final bool privacy;
  final AsList members;

  const GroupModel({
    required this.creatorId,
    this.description,
    this.privacy = true,
    this.logo,
    required this.name,
    this.members = const [],
    required super.id,
    super.createdAt,
    super.updatedAt,
  });

  @override
  GroupModel copyWith({
    String? id,
    String? logo,
    String? name,
    String? creatorId,
    String? description,
    List<String>? members,
    bool? privacy,
    DateTime? createdAt,
  }) => GroupModel(
    id: id ?? this.id,
    logo: logo ?? this.logo,
    creatorId: creatorId ?? this.creatorId,
    description: description ?? this.description,
    name: name ?? this.name,
    privacy: privacy ?? this.privacy,
    members: members ?? this.members,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: DateTime.now(),
  );

  @override
  List<Object?> get props => [
    ...super.props,
    logo,
    name,
    members,
    privacy,
    creatorId,
    description,
  ];

  factory GroupModel.fromMap(AsMap json) {
    final map = Model.convertJsonKeys(json, true);
    return GroupModel(
      id: map['id'],
      logo: map['logo'],
      name: map['name'],
      description: map['description'],
      creatorId: map['creatorId'],
      privacy: map['privacy'] ?? true,
      members: parseToList(map['members']),
      createdAt: Model.createOrUpdate(map),
      updatedAt: Model.createOrUpdate(map, false),
    );
  }

  @override
  AsMap toMap() {
    final data = {
      ...general,
      'logo': logo,
      'privacy': privacy,
      'members': members,
      'description': description,
      'creatorId': creatorId,
    };
    return Model.convertJsonKeys(data);
  }

  int get membersCount => members.length;
}
