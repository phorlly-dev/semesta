import 'package:semesta/app/utils/type_def.dart';
import 'package:semesta/core/models/model.dart';

enum NotifyType { like, reply, repost, mention, follow }

class NotifyModel extends Model<NotifyModel> {
  final String senderId;
  final String receiverId;
  final NotifyType type;
  final String? postId;
  final bool isRead;

  const NotifyModel({
    required this.senderId,
    required this.receiverId,
    required this.type,
    this.postId,
    this.isRead = false,
    required super.id,
    super.createdAt,
    super.updatedAt,
  });

  @override
  NotifyModel copyWith({
    String? senderId,
    String? id,
    String? receiverId,
    String? postId,
    NotifyType? type,
    bool? isRead,
    DateTime? createdAt,
  }) => NotifyModel(
    id: id ?? this.id,
    senderId: senderId ?? this.senderId,
    receiverId: receiverId ?? this.receiverId,
    type: type ?? this.type,
    postId: postId ?? this.postId,
    isRead: isRead ?? this.isRead,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: DateTime.now(),
  );

  @override
  List<Object?> get props => [
    ...super.props,
    senderId,
    receiverId,
    type,
    postId,
    isRead,
  ];

  factory NotifyModel.fromMap(AsMap json) {
    final map = Model.convertJsonKeys(json, true);
    return NotifyModel(
      id: map['id'],
      senderId: map['senderId'],
      receiverId: map['receiverId'],
      postId: map['postId'],
      type: NotifyType.values.firstWhere(
        (e) => e.name == map['type'],
        orElse: () => NotifyType.like,
      ),
      isRead: map['isRead'] ?? false,
      createdAt: Model.createOrUpdate(map),
      updatedAt: Model.createOrUpdate(map, false),
    );
  }

  @override
  AsMap toMap() {
    final data = {
      ...general,
      'postId': postId,
      'receiverId': receiverId,
      'senderId': senderId,
      'type': type.name,
      'isRead': isRead,
    };
    return Model.convertJsonKeys(data);
  }
}
