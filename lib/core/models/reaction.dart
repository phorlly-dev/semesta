import 'package:semesta/app/utils/type_def.dart';
import 'package:semesta/core/models/model.dart';

class Reaction {
  final String currentId, targetId;
  final DateTime createdAt;
  const Reaction({
    this.currentId = '',
    this.targetId = '',
    required this.createdAt,
  });

  factory Reaction.from(AsMap map) => Reaction(
    currentId: map['current_id'],
    targetId: map['target_id'],
    createdAt: Model.toDateTime(map['created_at']),
  );

  AsMap to() => {
    'current_id': currentId,
    'target_id': targetId,
    'created_at': Model.toEpoch(createdAt),
  };

  Reaction copy({
    String? currentId,
    String? targetId,
    DateTime? createdAt,
    bool? active,
  }) => Reaction(
    createdAt: createdAt ?? this.createdAt,
    currentId: currentId ?? this.currentId,
    targetId: targetId ?? this.targetId,
  );
}

class NestedReaction {
  final String currentId, betweenId, targetId;
  final DateTime createdAt;
  const NestedReaction({
    this.currentId = '',
    this.targetId = '',
    required this.createdAt,
    this.betweenId = '',
  });

  factory NestedReaction.from(AsMap map) => NestedReaction(
    currentId: map['current_id'],
    targetId: map['target_id'],
    betweenId: map['between_id'],
    createdAt: Model.toDateTime(map['created_at']),
  );

  AsMap to() => {
    'current_id': currentId,
    'between_id': betweenId,
    'target_id': targetId,
    'created_at': Model.toEpoch(createdAt),
  };

  NestedReaction copy({
    String? currentId,
    String? betweenId,
    String? targetId,
    DateTime? createdAt,
    bool? active,
  }) => NestedReaction(
    createdAt: createdAt ?? this.createdAt,
    currentId: currentId ?? this.currentId,
    betweenId: betweenId ?? this.betweenId,
    targetId: targetId ?? this.targetId,
  );
}
