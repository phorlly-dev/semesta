import 'package:semesta/app/functions/helpers.dart';
import 'package:semesta/app/utils/type_def.dart';
import 'package:semesta/core/models/model.dart';

class Group extends Model<Group> {
  final String logo;
  final String name;
  final String cid;
  final String note;
  final bool privacy;
  final AsList members;

  const Group({
    this.cid = '',
    this.note = '',
    this.privacy = true,
    this.logo = '',
    this.name = '',
    this.members = const [],
    super.id = '',
    super.createdAt,
    super.updatedAt,
    super.deletedAt,
  });

  @override
  Group copy({
    String? id,
    String? logo,
    String? name,
    String? cid,
    String? note,
    List<String>? members,
    bool? privacy,
    DateTime? createdAt,
    DateTime? deletedAt,
  }) => Group(
    id: id ?? this.id,
    logo: logo ?? this.logo,
    cid: cid ?? this.cid,
    note: note ?? this.note,
    name: name ?? this.name,
    privacy: privacy ?? this.privacy,
    members: members ?? this.members,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: DateTime.now(),
    deletedAt: deletedAt ?? this.deletedAt,
  );

  @override
  List<Object?> get props => [
    ...super.props,
    logo,
    name,
    members,
    privacy,
    cid,
    note,
  ];

  factory Group.from(AsMap json) {
    final map = Model.convertJsonKeys(json, true);
    return Group(
      id: map['id'],
      logo: map['logo'],
      name: map['name'],
      note: map['note'],
      cid: map['cid'],
      privacy: map['privacy'] ?? true,
      members: parseToList(map['members']),
      createdAt: Model.createOrUpdate(map),
      updatedAt: Model.createOrUpdate(map, false),
    );
  }

  @override
  AsMap to() {
    final data = {
      ...general,
      'logo': logo,
      'privacy': privacy,
      'members': members,
      'note': note,
      'cid': cid,
    };
    return Model.convertJsonKeys(data);
  }

  int get membersCount => members.length;
}
