import 'package:semesta/public/extensions/json_extension.dart';
import 'package:semesta/public/helpers/generic_helper.dart';
import 'package:semesta/public/utils/type_def.dart';

enum ReactionType {
  post,
  media,
  like,
  view,
  reply,
  repost,
  quote,
  save,
  share,
  follower,
  following,
}

class Reaction {
  final bool removed;
  final ReactionType type;
  final String id, tid;
  final DateTime createdAt;

  Reaction({
    this.id = '',
    this.tid = '',
    this.removed = false,
    this.type = ReactionType.like,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? now;

  factory Reaction.fromState(AsMap map) => Reaction(
    removed: map.asBool('removed'),
    id: map.id,
    tid: map.asText('tid'),
    type: map.asEnum('type', ReactionType.values),
    createdAt: map.created,
  );

  AsMap toPayload() => {
    'id': id,
    'tid': tid,
    'removed': removed,
    'type': type.name,
    'created_at': createdAt.millisecondsSinceEpoch,
  };

  Reaction copyWith({
    bool? removed,
    ReactionType? type,
    String? tid,
    String? id,
    DateTime? createdAt,
  }) => Reaction(
    type: type ?? this.type,
    removed: removed ?? this.removed,
    tid: tid ?? this.tid,
    createdAt: createdAt ?? this.createdAt,
    id: id ?? this.id,
  );
}
