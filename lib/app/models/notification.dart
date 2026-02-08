import 'package:semesta/public/functions/func_helper.dart';
import 'package:semesta/public/utils/type_def.dart';
import 'package:semesta/app/models/model.dart';

enum NotifyType { favorite, comment, repost, mention, follow }

class Notification extends IModel<Notification> {
  final String sender;
  final String reciever;
  final NotifyType type;
  final String pid;
  final bool readed;
  const Notification({
    this.pid = '',
    super.id = '',
    this.sender = '',
    this.reciever = '',
    this.readed = false,
    super.createdAt,
    super.updatedAt,
    this.type = NotifyType.favorite,
  });

  @override
  Notification copy({
    String? sender,
    String? id,
    String? reciever,
    String? pid,
    NotifyType? type,
    bool? readed,
    DateTime? createdAt,
  }) => Notification(
    id: id ?? this.id,
    sender: sender ?? this.sender,
    reciever: reciever ?? this.reciever,
    type: type ?? this.type,
    pid: pid ?? this.pid,
    readed: readed ?? this.readed,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: DateTime.now(),
  );

  @override
  List<Object?> get props => [
    ...super.props,
    sender,
    reciever,
    type,
    pid,
    readed,
  ];

  factory Notification.from(AsMap json) {
    final map = IModel.convert(json, true);
    return Notification(
      id: map['id'],
      sender: map['sender'],
      reciever: map['reciever'],
      pid: map['pid'],
      type: parseEnum(map['type'], NotifyType.values, NotifyType.favorite),
      readed: map['readed'] ?? false,
      createdAt: IModel.make(map),
      updatedAt: IModel.make(map, true),
    );
  }

  @override
  AsMap to() => IModel.convert({
    ...general,
    'pid': pid,
    'reciever': reciever,
    'sender': sender,
    'type': type.name,
    'readed': readed,
  });
}
