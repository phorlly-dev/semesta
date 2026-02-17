import 'package:semesta/public/extensions/json_extension.dart';
import 'package:semesta/public/helpers/feed_view.dart';
import 'package:semesta/public/helpers/generic_helper.dart';
import 'package:semesta/public/utils/type_def.dart';

class Reaction {
  final bool removed;
  final FeedKind kind;
  final String sid, did;
  final DateTime createdAt;

  Reaction({
    this.did = '',
    this.sid = '',
    this.removed = false,
    this.kind = FeedKind.likes,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? now;

  factory Reaction.fromState(AsMap map) => Reaction(
    removed: map.asBool('removed'),
    sid: map.asText('sid'),
    did: map.asText('did'),
    kind: map.asEnum('type', FeedKind.values),
    createdAt: map.created,
  );

  AsMap toPayload() => {
    'removed': removed,
    'type': kind.name,
    'did': did,
    'sid': sid,
    'created_at': createdAt.millisecondsSinceEpoch,
  };

  Reaction copyWith({
    bool? removed,
    FeedKind? kind,
    String? did,
    String? sid,
    DateTime? createdAt,
  }) => Reaction(
    kind: kind ?? this.kind,
    removed: removed ?? this.removed,
    did: did ?? this.did,
    createdAt: createdAt ?? this.createdAt,
    sid: sid ?? this.sid,
  );
}
