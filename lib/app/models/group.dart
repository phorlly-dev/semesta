import 'package:semesta/public/utils/type_def.dart';
import 'package:semesta/app/models/model.dart';

class Group extends IModel<Group> {
  final String logo;
  final String name;
  final String creator;
  final String note;
  final bool privacy;
  const Group({
    super.id = '',
    this.logo = '',
    this.name = '',
    this.note = '',
    this.creator = '',
    this.privacy = true,
    super.createdAt,
    super.updatedAt,
    super.deletedAt,
  });

  @override
  Group copy({
    String? id,
    String? logo,
    String? name,
    String? creator,
    String? note,
    bool? privacy,
    DateTime? createdAt,
    DateTime? deletedAt,
  }) => Group(
    id: id ?? this.id,
    logo: logo ?? this.logo,
    creator: creator ?? this.creator,
    note: note ?? this.note,
    name: name ?? this.name,
    privacy: privacy ?? this.privacy,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: DateTime.now(),
    deletedAt: deletedAt ?? this.deletedAt,
  );

  @override
  List<Object?> get props => [
    ...super.props,
    logo,
    name,
    privacy,
    creator,
    note,
  ];

  factory Group.from(AsMap json) {
    final map = IModel.convert(json, true);
    return Group(
      id: map['id'],
      logo: map['logo'],
      name: map['name'],
      note: map['note'],
      creator: map['creator'],
      privacy: map['privacy'] ?? true,
      createdAt: IModel.make(map),
      updatedAt: IModel.make(map, true),
    );
  }

  @override
  AsMap to() => IModel.convert({
    ...general,
    'logo': logo,
    'privacy': privacy,
    'note': note.trim(),
    'creator': creator,
  });
}
