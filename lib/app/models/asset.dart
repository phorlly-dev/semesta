import 'package:semesta/app/models/model.dart';
import 'package:semesta/public/helpers/generic_helper.dart';
import 'package:semesta/public/utils/type_def.dart';

class Asset extends IModel<Asset> {
  final String name, uname;
  final String avatar;
  final String cover;
  const Asset({
    super.id = '',
    this.name = '',
    this.uname = '',
    this.avatar = '',
    this.cover = '',
    super.createdAt,
    super.updatedAt,
  });

  factory Asset.from(AsMap json) {
    final map = IModel.convert(json, true);
    return Asset(
      id: map['id'],
      name: map['name'],
      uname: map['uname'],
      cover: map['cover'],
      avatar: map['avatar'],
      createdAt: IModel.make(map),
      updatedAt: IModel.make(map, true),
    );
  }

  @override
  AsMap to() => IModel.convert({
    ...general,
    'id': id,
    'cover': cover,
    'avatar': avatar,
    'name': name.trim(),
    'uname': uname.trim(),
  });

  @override
  Asset copy({
    String? id,
    String? name,
    String? uname,
    String? cover,
    String? avatar,
    DateTime? createdAt,
  }) => Asset(
    id: id ?? this.id,
    name: name ?? this.name,
    uname: uname ?? this.uname,
    avatar: avatar ?? this.avatar,
    cover: cover ?? this.cover,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: now,
  );

  @override
  List<Object?> get props => [...super.props, name, uname, avatar, cover];
}
