import 'package:semesta/public/extensions/json_extension.dart';
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
    super.id,
    this.sender = '',
    this.reciever = '',
    this.readed = false,
    super.createdAt,
    super.updatedAt,
    this.type = NotifyType.favorite,
  });

  @override
  Notification copyWith({
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

  factory Notification.fromState(AsMap json) => Notification(
    id: json.id,
    pid: json.pid,
    readed: json.asBool('readed'),
    sender: json.asText('sender'),
    reciever: json.asText('reciever'),
    type: json.asEnum('type', NotifyType.values),
    createdAt: json.created,
    updatedAt: json.updated,
  );

  @override
  AsMap toPayload() => {
    ...general,
    'pid': pid,
    'reciever': reciever,
    'sender': sender,
    'type': type.name,
    'readed': readed,
  };
}
