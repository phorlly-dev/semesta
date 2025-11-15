import 'package:semesta/app/utils/json_helpers.dart';
import 'package:semesta/core/models/reaction_model.dart';
import 'package:semesta/core/models/model.dart';

enum CommentType { text, image, gif, mixed }

class CommentModel extends Model<CommentModel> {
  final String postId;
  final String userId;
  final CommentType type; // text, image, gif, mixed
  final String? text;
  final String? imageUrl;
  final String? gifUrl;
  final List<String>? mentions; // user IDs of mentioned people
  final List<String>? emojis; // store emoji unicode or shortcode
  final ReactionModel? reaction;
  final List<String>? replyIds;

  const CommentModel({
    required this.postId,
    required this.userId,
    this.type = CommentType.text,
    this.text,
    this.imageUrl,
    this.gifUrl,
    this.mentions,
    this.emojis,
    this.reaction,
    this.replyIds,
    super.id,
    super.createdAt,
    super.updatedAt,
  });

  @override
  CommentModel copyWith({
    String? id,
    String? postId,
    String? userId,
    CommentType? type,
    String? text,
    String? imageUrl,
    String? gifUrl,
    List<String>? mentions,
    List<String>? emojis,
    ReactionModel? reaction,
    List<String>? replyIds,
  }) => CommentModel(
    id: id ?? this.id,
    postId: postId ?? this.postId,
    userId: userId ?? this.userId,
    type: type ?? this.type,
    text: text ?? this.text,
    imageUrl: imageUrl ?? this.imageUrl,
    gifUrl: gifUrl ?? this.gifUrl,
    mentions: mentions ?? this.mentions,
    emojis: emojis ?? this.emojis,
    reaction: reaction ?? this.reaction,
    replyIds: replyIds ?? this.replyIds,
    createdAt: createdAt,
    updatedAt: DateTime.now(),
  );

  @override
  List<Object?> get props => [
    ...super.props,
    postId,
    userId,
    type,
    text,
    imageUrl,
    gifUrl,
    mentions,
    emojis,
    reaction,
    replyIds,
  ];

  factory CommentModel.fromMap(Map<String, dynamic> json) {
    final map = Model.convertJsonKeys(json, toCamelCase: true);
    return CommentModel(
      id: map['id'] ?? '',
      postId: map['postId'] ?? '',
      userId: map['userId'] ?? '',
      text: map['text'],
      type: CommentType.values.firstWhere(
        (e) => e.name == map['type'],
        orElse: () => CommentType.text,
      ),
      imageUrl: map['imageUrl'],
      gifUrl: map['gifUrl'],
      mentions: parseTo(map['mentions']),
      emojis: parseTo(map['emojis']),
      reaction: safeParse<ReactionModel>(
        map['reaction'],
        ReactionModel.fromMap,
      ),
      replyIds: parseTo(map['replyIds']),
      createdAt: Model.createOrUpdate(map),
      updatedAt: Model.createOrUpdate(map, false),
    );
  }

  @override
  Map<String, dynamic> toMap() {
    final data = {
      ...general,
      'postId': postId,
      'userId': userId,
      'type': type.name,
      'text': text,
      'imageUrl': imageUrl,
      'gifUrl': gifUrl,
      'mentions': mentions ?? const [],
      'emojis': emojis,
      'reaction': reaction?.toMap(),
      'replyIds': replyIds,
    };
    return Model.convertJsonKeys(data);
  }
}
