import 'package:semesta/app/utils/type_def.dart';
import 'package:semesta/core/models/model.dart';

enum NotifyType { favorite, comment, repost, mention, follow }

class Notification extends Model<Notification> {
  final String sender;
  final String reciever;
  final NotifyType type;
  final String pid;
  final bool readed;

  const Notification({
    required this.sender,
    required this.reciever,
    this.type = NotifyType.favorite,
    this.pid = '',
    this.readed = false,
    super.id = '',
    super.createdAt,
    super.updatedAt,
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
    final map = Model.convertJsonKeys(json, true);
    return Notification(
      id: map['id'],
      sender: map['sender'],
      reciever: map['reciever'],
      pid: map['pid'],
      type: NotifyType.values.firstWhere(
        (e) => e.name == map['type'],
        orElse: () => NotifyType.favorite,
      ),
      readed: map['readed'] ?? false,
      createdAt: Model.createOrUpdate(map),
      updatedAt: Model.createOrUpdate(map, false),
    );
  }

  @override
  AsMap to() {
    final data = {
      ...general,
      'pid': pid,
      'reciever': reciever,
      'sender': sender,
      'type': type.name,
      'readed': readed,
    };
    return Model.convertJsonKeys(data);
  }
}
