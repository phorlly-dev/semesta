import 'package:semesta/app/models/model.dart';
import 'package:semesta/public/extensions/json_extension.dart';
import 'package:semesta/public/helpers/generic_helper.dart';
import 'package:semesta/public/utils/type_def.dart';

class Hashtag extends IModel<Hashtag> {
  final int counts;
  final double scores;
  final bool banned;
  const Hashtag({
    super.id = '',
    super.name = '',
    this.counts = 0,
    this.scores = 0,
    this.banned = false,
    super.createdAt,
    super.lastUsedAt,
  });

  @override
  Hashtag copyWith({
    String? id,
    int? counts,
    String? name,
    bool? banned,
    double? scores,
    String? display,
    DateTime? createdAt,
    DateTime? lastUsedAt,
  }) => Hashtag(
    id: id ?? this.id,
    name: name ?? this.name,
    banned: banned ?? this.banned,
    counts: counts ?? this.counts,
    scores: scores ?? this.scores,
    lastUsedAt: lastUsedAt ?? now,
    createdAt: createdAt ?? this.createdAt,
  );

  factory Hashtag.fromState(AsMap json) => Hashtag(
    id: json.id,
    name: json.name,
    scores: json.asDouble('scores'),
    counts: json.asInt('counts'),
    banned: json.asBool('banned'),
    createdAt: json.created,
    lastUsedAt: json.lastUsed,
  );

  @override
  AsMap toPayload() => {
    'id': id.trim(),
    'name': name.trim(),
    'counts': counts,
    'banned': banned,
    'scores': scores,
    'created_at': createdAt,
    'last_used_at': lastUsedAt,
  };
}
