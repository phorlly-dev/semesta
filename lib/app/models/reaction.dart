import 'package:semesta/public/utils/type_def.dart';
import 'package:semesta/app/models/model.dart';
import 'package:semesta/public/helpers/utils_helper.dart';

class Reaction {
  final bool exist;
  final FeedKind kind;
  final DateTime createdAt;
  final String currentId, targetId;
  const Reaction({
    this.exist = true,
    this.targetId = '',
    this.currentId = '',
    required this.createdAt,
    this.kind = FeedKind.liked,
  });

  factory Reaction.from(AsMap map) => Reaction(
    exist: map['exist'],
    targetId: map['target_id'],
    currentId: map['current_id'],
    kind: FeedKind.values.firstWhere(
      (e) => e.name == map['kind'],
      orElse: () => FeedKind.liked,
    ),
    createdAt: Model.toDateTime(map['created_at']),
  );

  AsMap to() => {
    'kind': kind.name,
    'exist': exist,
    'target_id': targetId,
    'current_id': currentId,
    'created_at': Model.toEpoch(createdAt),
  };

  Reaction copy({
    bool? exist,
    FeedKind? kind,
    String? targetId,
    String? currentId,
    DateTime? createdAt,
  }) => Reaction(
    kind: kind ?? this.kind,
    exist: exist ?? this.exist,
    targetId: targetId ?? this.targetId,
    createdAt: createdAt ?? this.createdAt,
    currentId: currentId ?? this.currentId,
  );
}
