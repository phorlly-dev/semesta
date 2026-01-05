import 'package:semesta/app/functions/helpers.dart';
import 'package:semesta/app/utils/type_def.dart';
import 'package:semesta/core/models/media.dart';
import 'package:semesta/core/models/model.dart';

enum Post { post, comment, quote }

enum Visible { everyone, verified, following, mentioned }

class Feed extends Model<Feed> {
  final String uid;

  final String content;
  final String location;
  final List<Media> media;

  final Post type;
  final String pid;
  final Visible visible;

  final int favoritesCount;
  final int viewsCount;
  final int commentsCount;
  final int repostsCount;
  final int bookmarksCount;
  final int sharesCount;

  final bool edited;
  final bool removed;

  final AsList hashtags;
  final AsList mentions;

  const Feed({
    super.id = '',
    this.uid = '',
    this.content = '',
    this.media = const [],
    this.location = '',
    this.visible = Visible.everyone,
    this.hashtags = const [],
    this.mentions = const [],
    this.type = Post.post,
    this.pid = '',
    this.edited = false,
    this.removed = false,
    this.favoritesCount = 0,
    this.viewsCount = 0,
    this.commentsCount = 0,
    this.repostsCount = 0,
    this.bookmarksCount = 0,
    this.sharesCount = 0,
    super.createdAt,
    super.updatedAt,
    super.deletedAt,
  });

  @override
  Feed copy({
    String? id,
    String? uid,
    String? content,
    List<Media>? media,
    String? location,
    Visible? visible,
    int? favoritesCount,
    int? viewsCount,
    int? commentsCount,
    int? repostsCount,
    int? bookmarksCount,
    int? sharesCount,
    Post? type,
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
    content: content ?? this.content,
    pid: pid ?? this.pid,
    hashtags: hashtags ?? this.hashtags,
    media: media ?? this.media,
    edited: edited ?? this.edited,
    removed: removed ?? this.removed,
    location: location ?? this.location,
    visible: visible ?? this.visible,
    type: type ?? this.type,
    favoritesCount: favoritesCount ?? this.favoritesCount,
    commentsCount: commentsCount ?? this.commentsCount,
    repostsCount: repostsCount ?? this.repostsCount,
    bookmarksCount: bookmarksCount ?? this.bookmarksCount,
    sharesCount: sharesCount ?? this.sharesCount,
    viewsCount: viewsCount ?? this.viewsCount,
    mentions: mentions ?? this.mentions,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: DateTime.now(),
    deletedAt: deletedAt ?? this.deletedAt,
  );

  @override
  List<Object?> get props => [
    ...super.props,
    uid,
    removed,
    content,
    media,
    location,
    visible,
    edited,
    pid,
    hashtags,
    mentions,
    type,
    favoritesCount,
    viewsCount,
    commentsCount,
    repostsCount,
    bookmarksCount,
    sharesCount,
  ];

  factory Feed.from(AsMap json) {
    final map = Model.convertJsonKeys(json, true);
    return Feed(
      id: map['id'],
      uid: map['uid'],
      content: map['content'],
      location: map['location'],
      pid: map['pid'],
      edited: map['edited'] ?? false,
      removed: map['removed'] ?? false,
      favoritesCount: map['favoritesCount'] ?? 0,
      commentsCount: map['commentsCount'] ?? 0,
      repostsCount: map['repostsCount'] ?? 0,
      bookmarksCount: map['bookmarksCount'] ?? 0,
      sharesCount: map['sharesCount'] ?? 0,
      viewsCount: map['viewsCount'] ?? 0,
      hashtags: parseToList(map['hashtags']),
      mentions: parseToList(map['mentions']),
      media: parseJsonList<Media>(map['media'], Media.from),
      visible: Visible.values.firstWhere(
        (e) => e.name == map['visible'],
        orElse: () => Visible.everyone,
      ),
      type: Post.values.firstWhere(
        (e) => e.name == map['type'],
        orElse: () => Post.post,
      ),
      createdAt: Model.createOrUpdate(map),
      updatedAt: Model.createOrUpdate(map, false),
    );
  }

  @override
  AsMap to() {
    final data = {
      ...general,
      'content': content,
      'uid': uid,
      'edited': edited,
      'removed': removed,
      'location': location,
      'pid': pid,
      'hashtags': hashtags.toList(),
      'mentions': mentions.toList(),
      'media': media.map((e) => e.to()),
      'type': type.name,
      'favoritesCount': favoritesCount,
      'commentsCount': commentsCount,
      'repostsCount': repostsCount,
      'bookmarksCount': bookmarksCount,
      'sharesCount': sharesCount,
      'viewsCount': viewsCount,
      'visible': visible.name,
    };
    return Model.convertJsonKeys(data);
  }
}
