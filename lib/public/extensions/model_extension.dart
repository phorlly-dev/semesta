import 'package:semesta/app/models/feed.dart';
import 'package:semesta/app/models/media.dart';
import 'package:semesta/public/helpers/generic_helper.dart';
import 'package:semesta/public/utils/type_def.dart';

extension FeedX on Feed {
  bool get posted => type == Create.post;
  bool get hasQuote => type == Create.quote && pid.isNotEmpty;
  bool get hasComment => type == Create.reply && pid.isNotEmpty;

  bool get isEditable {
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
}

extension MediaX on Media {
  bool get img => type == MediaType.image;
  bool get mp4 => type == MediaType.video;
}
