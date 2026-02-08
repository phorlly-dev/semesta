import 'package:semesta/public/functions/func_helper.dart';
import 'package:semesta/public/helpers/generic_helper.dart';
import 'package:semesta/public/utils/type_def.dart';
import 'package:semesta/app/models/media.dart';
import 'package:semesta/app/models/model.dart';
import 'package:semesta/app/models/stats_count.dart';

enum Create { post, reply, quote }

enum Visible { everyone, verified, following, mentioned }

class Feed extends IModel<Feed> {
  final String uid;

  final String title;
  final String location;
  final List<Media> media;
  final StatsCount stats;

  final Create type;
  final String pid;
  final Visible visible;

  final bool edited;
  final bool removed;

  final AsList hashtags;
  final AsList mentions;

  const Feed({
    super.id = '',
    this.uid = '',
    this.title = '',
    this.media = const [],
    this.location = '',
    this.visible = Visible.everyone,
    this.hashtags = const [],
    this.mentions = const [],
    this.type = Create.post,
    this.pid = '',
    this.edited = false,
    this.removed = false,
    super.createdAt,
    super.updatedAt,
    super.deletedAt,
    this.stats = const StatsCount(),
  });

  @override
  Feed copy({
    String? id,
    String? uid,
    String? title,
    List<Media>? media,
    String? location,
    Visible? visible,
    StatsCount? stats,
    Create? type,
    bool? edited,
    bool? removed,
    String? pid,
    AsList? hashtags,
    AsList? mentions,
    DateTime? createdAt,
    DateTime? deletedAt,
  }) => Feed(
    id: id ?? this.id,
    uid: uid ?? this.uid,
    title: title ?? this.title,
    pid: pid ?? this.pid,
    hashtags: hashtags ?? this.hashtags,
    media: media ?? this.media,
    edited: edited ?? this.edited,
    removed: removed ?? this.removed,
    location: location ?? this.location,
    visible: visible ?? this.visible,
    type: type ?? this.type,
    stats: stats ?? this.stats,
    mentions: mentions ?? this.mentions,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: now,
    deletedAt: deletedAt ?? this.deletedAt,
  );

  @override
  List<Object?> get props => [
    ...super.props,
    uid,
    removed,
    title,
    media,
    location,
    visible,
    edited,
    pid,
    hashtags,
    mentions,
    type,
    stats,
  ];

  factory Feed.from(AsMap json) {
    final map = IModel.convert(json, true);
    return Feed(
      id: map['id'],
      uid: map['uid'],
      title: map['title'],
      location: map['location'],
      pid: map['pid'],
      edited: map['edited'] ?? false,
      removed: map['removed'] ?? false,
      stats: castToMap(map['stats'], StatsCount.from),
      hashtags: parseToList(map['hashtags']),
      mentions: parseToList(map['mentions']),
      media: parseJsonList(map['media'], Media.from),
      type: parseEnum(map['type'], Create.values, Create.post),
      visible: parseEnum(map['visible'], Visible.values, Visible.everyone),
      createdAt: IModel.make(map),
      updatedAt: IModel.make(map, true),
    );
  }

  @override
  AsMap to() => IModel.convert({
    ...general,
    'uid': uid,
    'pid': pid,
    'edited': edited,
    'type': type.name,
    'removed': removed,
    'title': title.trim(),
    'location': location.trim(),
    'hashtags': hashtags,
    'mentions': mentions,
    'media': media.map((e) => e.to()),
    'stats': stats.to(),
    'visible': visible.name,
  });
}
