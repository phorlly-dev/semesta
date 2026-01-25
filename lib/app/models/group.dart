import 'package:semesta/public/utils/type_def.dart';
import 'package:semesta/app/models/model.dart';

class Group extends Model<Group> {
  final String logo;
  final String name;
  final String cid;
  final String note;
  final bool privacy;

  const Group({
    this.cid = '',
    this.note = '',
    this.privacy = true,
    this.logo = '',
    this.name = '',
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
    createdAt: createdAt ?? this.createdAt,
    updatedAt: DateTime.now(),
    deletedAt: deletedAt ?? this.deletedAt,
  );

  @override
  List<Object?> get props => [...super.props, logo, name, privacy, cid, note];

  factory Group.from(AsMap json) {
    final map = Model.convertJsonKeys(json, true);
    return Group(
      id: map['id'],
      logo: map['logo'],
      name: map['name'],
      note: map['note'],
      cid: map['cid'],
      privacy: map['privacy'] ?? true,
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
      'note': note,
      'cid': cid,
    };
    return Model.convertJsonKeys(data);
  }
}
