import 'package:semesta/public/functions/func_helper.dart';
import 'package:semesta/public/helpers/feed_view.dart';
import 'package:semesta/public/helpers/generic_helper.dart';
import 'package:semesta/public/utils/type_def.dart';
import 'package:semesta/app/models/model.dart';

class Reaction {
  final bool exist;
  final FeedKind kind;
  final DateTime createdAt;
  final String currentId, targetId;

  Reaction({
    this.exist = true,
    this.targetId = '',
    this.currentId = '',
    this.kind = FeedKind.liked,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? now;

  factory Reaction.from(AsMap json) {
    final map = IModel.convert(json, true);
    return Reaction(
      exist: map['exist'] ?? false,
      targetId: map['targetId'],
      currentId: map['currentId'],
      kind: parseEnum(map['kind'], FeedKind.values, FeedKind.liked),
      createdAt: IModel.make(map),
    );
  }

  AsMap to() => IModel.convert({
    'exist': exist,
    'kind': kind.name,
    'targetId': targetId,
    'currentId': currentId,
    'createdAt': IModel.toEpoch(createdAt),
  });

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
