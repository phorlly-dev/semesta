import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:semesta/core/models/model.dart';

class NotifyModel extends Model<NotifyModel> {
  final String content;
  final List<String>? bold;
  final String image;
  final String type;
  final bool seen;

  const NotifyModel({
    required this.content,
    this.bold,
    required this.image,
    required this.type,
    this.seen = false,
    required super.id,
    super.createdAt,
    super.updatedAt,
  });

  @override
  NotifyModel copyWith({
    String? content,
    List<String>? bold,
    String? image,
    String? time,
    String? type,
    bool? seen,
  }) {
    return NotifyModel(
      id: id,
      content: content ?? this.content,
      bold: bold ?? this.bold,
      image: image ?? this.image,
      type: type ?? this.type,
      seen: seen ?? this.seen,
      createdAt: createdAt,
      updatedAt: Timestamp.now(),
    );
  }

  @override
  List<Object?> get props => [...super.props, content, bold, image, type, seen];

  factory NotifyModel.fromMap(Map<String, dynamic> map) => NotifyModel(
    id: map['id'],
    content: map['content'],
    bold: map['bold'],
    image: map['image'],
    type: map['type'],
    seen: map['seen'] ?? false,
    createdAt: map['created_at'] ?? Timestamp.now(),
    updatedAt: map['updated_at'] ?? Timestamp.now(),
  );

  @override
  Map<String, dynamic> toMap() => {
    'id': id,
    'content': content,
    'bold': bold,
    'image': image,
    'type': type,
    'seen': seen,
    'created_at': createdAt ?? Timestamp.now(),
    'updated_at': updatedAt ?? Timestamp.now(),
  };
}

/* NOTIFICATIONS TYPES:

1. page
2. group
3. comment
4. friend
5. security
6. date
7. badge
8-14: reactions: like, haha, love, lovelove, sad, wow, angry
15: memory
 */
