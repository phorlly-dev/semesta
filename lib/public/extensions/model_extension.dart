import 'package:semesta/app/models/feed.dart';
import 'package:semesta/app/models/media.dart';
import 'package:semesta/public/helpers/class_helper.dart';
import 'package:semesta/public/helpers/feed_view.dart';
import 'package:semesta/public/helpers/generic_helper.dart';
import 'package:semesta/public/utils/type_def.dart';

extension FeedX on Feed {
  bool get posted => type == Create.post;
  bool get hasQuote => type == Create.quote && pid.isNotEmpty;
  bool get hasComment => type == Create.reply && pid.isNotEmpty;

  bool get editable {
    final created = createdAt;
    if (created == null) return false;
    return now.difference(created) <= const Duration(minutes: 15);
  }

  String formatMMSS(Duration d) {
    final m = d.inMinutes;
    final s = d.inSeconds % 60;
    return '$m:${s.toString().padLeft(2, '0')}';
  }

  Sync<Duration> get editCountdown$ async* {
    final created = createdAt;
    if (created == null) return;

    const limit = Duration(minutes: 15);

    while (true) {
      final elapsed = now.difference(created);
      final remaining = limit - elapsed;

      if (remaining <= Duration.zero) {
        yield Duration.zero;
        break;
      }

      yield remaining;
      await Future.delayed(const Duration(seconds: 1));
    }
  }

  String get toDoc => hasComment ? '$pid/$comments/$id' : id;

  ActionTarget get getTarget {
    return hasComment ? ChildTarget(pid, id) : ParentTarget(id);
  }

  String toId({String puid = '', FeedKind kind = FeedKind.posted}) =>
      switch (kind) {
        FeedKind.quoted => 'q:$id',
        FeedKind.posted => 'p:$id',
        FeedKind.viewed => 'v:$id',
        FeedKind.follower => 'fr:$puid',
        FeedKind.following => 'fi:$puid',
        FeedKind.saved => 'b:$puid:$id',
        FeedKind.media => 'm:$puid:$id',
        FeedKind.liked => 'l:$puid:$id',
        FeedKind.shared => 's:$puid:$id',
        FeedKind.replied => 'c:$puid:$id',
        FeedKind.reposted => 'r:$puid:$id',
      };
}

extension MediaX on Media {
  bool get img => type == MediaType.image;
  bool get mp4 => type == MediaType.video;
}

extension ActionTargetX on ActionTarget {
  String get toKey => switch (this) {
    ParentTarget(:final pid) => 'p:$pid',
    ChildTarget(:final pid, :final cid) => 'c:$pid:$cid',
  };

  String toPath(
    String id, {
    String rcol = posts,
    String pcol = comments,
    String ccol = favorites,
  }) => switch (this) {
    ParentTarget(:final pid) => '$rcol/$pid/$ccol/$id',
    ChildTarget(:final pid, :final cid) => '$rcol/$pid/$pcol/$cid/$ccol/$id',
  };
}
