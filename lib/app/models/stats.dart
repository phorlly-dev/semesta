import 'package:semesta/public/extensions/json_extension.dart';
import 'package:semesta/public/utils/type_def.dart';

class StatsCount {
  final int likes;
  final int views;
  final int replies;
  final int reposts;
  final int quotes;
  final int saves;
  final int shares;
  const StatsCount({
    this.likes = 0,
    this.views = 0,
    this.replies = 0,
    this.reposts = 0,
    this.quotes = 0,
    this.saves = 0,
    this.shares = 0,
  });

  factory StatsCount.fromState(AsMap map) => StatsCount(
    likes: map.asInt('likes'),
    views: map.asInt('views'),
    replies: map.asInt('replies'),
    reposts: map.asInt('reposts'),
    quotes: map.asInt('quotes'),
    saves: map.asInt('saves'),
    shares: map.asInt('shares'),
  );

  AsMap toPayload() => {
    'likes': likes,
    'views': views,
    'replies': replies,
    'reposts': reposts,
    'quotes': quotes,
    'saves': saves,
    'shares': shares,
  };

  StatsCount copyWith({
    int? likes,
    int? views,
    int? replies,
    int? reposts,
    int? quotes,
    int? saves,
    int? shares,
  }) => StatsCount(
    likes: likes ?? this.likes,
    quotes: quotes ?? this.quotes,
    replies: replies ?? this.replies,
    reposts: reposts ?? this.reposts,
    saves: saves ?? this.saves,
    shares: shares ?? this.shares,
    views: views ?? this.views,
  );
}

class DailyCount {
  final String id;
  final int counts;
  final DateTime? createdAt;
  const DailyCount({this.id = '', this.counts = 0, this.createdAt});

  factory DailyCount.fromState(AsMap json) => DailyCount(
    id: json.id,
    counts: json.asInt('counts'),
    createdAt: json.created,
  );

  DailyCount copyWith({String? id, int? counts, DateTime? createdAt}) {
    return DailyCount(
      id: id ?? this.id,
      counts: counts ?? this.counts,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  AsMap toPayload() => {'id': id, 'counts': counts, 'created_at': createdAt};
}
