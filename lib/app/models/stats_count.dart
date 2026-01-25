import 'package:semesta/public/utils/type_def.dart';

class StatsCount {
  final int liked;
  final int viewed;
  final int replied;
  final int reposted;
  final int quoted;
  final int saved;
  final int shared;
  const StatsCount({
    this.liked = 0,
    this.viewed = 0,
    this.replied = 0,
    this.reposted = 0,
    this.quoted = 0,
    this.saved = 0,
    this.shared = 0,
  });

  factory StatsCount.from(AsMap map) => StatsCount(
    liked: map['liked'] ?? 0,
    viewed: map['viewed'] ?? 0,
    replied: map['replied'] ?? 0,
    reposted: map['reposted'] ?? 0,
    quoted: map['quoted'] ?? 0,
    saved: map['saved'] ?? 0,
    shared: map['shared'] ?? 0,
  );

  AsMap to() => {
    'liked': liked,
    'viewed': viewed,
    'replied': replied,
    'reposted': reposted,
    'quoted': quoted,
    'saved': saved,
    'shared': shared,
  };

  StatsCount copy({
    int? liked,
    int? viewed,
    int? replied,
    int? reposted,
    int? quoted,
    int? saved,
    int? shared,
  }) => StatsCount(
    liked: liked ?? this.liked,
    quoted: quoted ?? this.quoted,
    replied: replied ?? this.replied,
    reposted: reposted ?? this.reposted,
    saved: saved ?? this.saved,
    shared: shared ?? this.shared,
    viewed: viewed ?? this.viewed,
  );
}
