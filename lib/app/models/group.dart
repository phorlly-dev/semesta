import 'package:semesta/public/extensions/json_extension.dart';
import 'package:semesta/public/utils/type_def.dart';
import 'package:semesta/app/models/model.dart';

class Group extends IModel<Group> {
  final String logo;
  final String creator;
  final String note;
  final bool privacy;
  const Group({
    super.id,
    this.logo = '',
    super.name,
    this.note = '',
    this.creator = '',
    this.privacy = true,
    super.createdAt,
    super.updatedAt,
    super.deletedAt,
  });

  @override
  Group copyWith({
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
  List<Object?> get props => [...super.props, logo, privacy, creator, note];

  factory Group.fromState(AsMap map) => Group(
    id: map.id,
    name: map.name,
    logo: map.asText('logo'),
    note: map.asText('note'),
    creator: map.asText('creator'),
    privacy: map.asBool('privacy'),
    createdAt: map.created,
    updatedAt: map.updated,
  );

  @override
  AsMap toPayload() => {
    ...general,
    'logo': logo,
    'privacy': privacy,
    'note': note.trim(),
    'creator': creator,
  };
}
