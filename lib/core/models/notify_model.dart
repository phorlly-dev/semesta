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
    super.id,
    super.createdAt,
    super.updatedAt,
  });

  @override
  NotifyModel copyWith({
    String? content,
    String? id,
    List<String>? bold,
    String? image,
    String? time,
    String? type,
    bool? seen,
  }) => NotifyModel(
    id: id ?? this.id,
    content: content ?? this.content,
    bold: bold ?? this.bold,
    image: image ?? this.image,
    type: type ?? this.type,
    seen: seen ?? this.seen,
    createdAt: createdAt,
    updatedAt: DateTime.now(),
  );

  @override
  List<Object?> get props => [...super.props, content, bold, image, type, seen];

  factory NotifyModel.fromMap(Map<String, dynamic> json) {
    final map = Model.convertJsonKeys(json, toCamelCase: true);
    return NotifyModel(
      id: map['id'],
      content: map['content'],
      bold: map['bold'],
      image: map['image'],
      type: map['type'],
      seen: map['seen'] ?? false,
      createdAt: Model.createOrUpdate(map),
      updatedAt: Model.createOrUpdate(map, false),
    );
  }

  @override
  Map<String, dynamic> toMap() {
    final data = {
      ...general,
      'content': content,
      'bold': bold,
      'image': image,
      'type': type,
      'seen': seen,
    };
    return Model.convertJsonKeys(data);
  }
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
