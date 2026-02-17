import 'package:semesta/app/models/feed.dart';
import 'package:semesta/app/models/hashtag.dart';
import 'package:semesta/app/models/media.dart';
import 'package:semesta/public/helpers/audit_view.dart';
import 'package:semesta/public/helpers/class_helper.dart';
import 'package:semesta/public/helpers/feed_view.dart';
import 'package:semesta/public/helpers/generic_helper.dart';
import 'package:semesta/public/helpers/params_helper.dart';
import 'package:semesta/public/utils/type_def.dart';

extension FeedX on Feed {
  bool get posted => type == Create.post;
  bool get hasQuote => type == Create.quote && pid.isNotEmpty;
  bool get hasComment => type == Create.reply && pid.isNotEmpty;

  Feed get reply => hasComment ? this : Feed();
  Feed get repost => hasQuote ? this : Feed();

  /// A helper method to determine if a feed item is editable based on its creation time,
  /// used to allow users to edit their posts within a certain time frame after posting.
  bool get editable {
    final created = createdAt;
    if (created == null) return false;
    return now.difference(created) <= const Duration(minutes: 15);
  }

  /// A helper method to format a Duration into a MM:SS string, used for displaying the remaining edit time in a user-friendly format.
  String formatMMSS(Duration d) {
    final m = d.inMinutes;
    final s = d.inSeconds % 60;
    return '$m:${s.toString().padLeft(2, '0')}';
  }

  /// A stream that emits the remaining time for editing a feed item,
  /// updating every second until the edit time limit is reached,
  /// used to provide real-time feedback to users on how much time they have left to edit their post.
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

  /// Path for reactions, if it's a comment, the path will be 'p/{pid}/comments/{id}', otherwise it will be 'p/{id}'.
  String get toDoc => hasComment ? '$pid/$comments/$id' : id;

  /// A helper method to determine the appropriate action target for a feed item,
  /// used to correctly route user interactions (like, save, repost) to the correct database path based on whether the item is a post or a comment.
  ActionTarget get getTarget {
    return hasComment ? ChildTarget(pid, id) : ParentTarget(id);
  }

  /// A helper method to generate a unique identifier for a feed item based on its type and ID,
  /// used for consistent referencing of feed items in the database and UI.
  String toId({String puid = '', FeedKind kind = FeedKind.posts}) {
    return switch (kind) {
      FeedKind.quotes => 'q:$id',
      FeedKind.posts => 'p:$id',
      FeedKind.views => 'v:$id',
      FeedKind.followers => 'fr:$puid',
      FeedKind.following => 'fi:$puid',
      FeedKind.saves => 'b:$puid:$id',
      FeedKind.media => 'm:$puid:$id',
      FeedKind.likes => 'l:$puid:$id',
      FeedKind.shares => 's:$puid:$id',
      FeedKind.replies => 'c:$puid:$id',
      FeedKind.reposts => 'r:$puid:$id',
    };
  }
}

extension MediaX on Media {
  bool get img => type == MediaType.image;
  bool get mp4 => type == MediaType.video;
}

extension ActionTargetX on ActionTarget {
  /// A helper method to generate a unique key for an action target based on its type and IDs,
  /// used for consistent referencing of action targets in the database and UI.
  String get toKey => switch (this) {
    ParentTarget(:final pid) => 'p:$pid',
    ChildTarget(:final pid, :final cid) => 'c:$pid:$cid',
  };

  /// A helper method to generate a database path for an action target based on its type and IDs,
  /// used for routing user interactions (like, save, repost) to the correct database path.
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

extension StatusViewX on StatusView {
  /// A helper method to determine the appropriate follow state based on the current relationship with the user,
  /// used to render the correct follow/unfollow button state in the UI.
  String get followBanner {
    if (iFollow && !theyFollow) {
      return 'Following';
    } else if (!iFollow && theyFollow) {
      return 'Follows you';
    } else if (iFollow && theyFollow) {
      return 'You follow each other';
    } else {
      return '';
    }
  }

  /// A helper method to determine the appropriate follow action based on the current relationship with the user,
  /// used to perform the correct follow/unfollow action when the user interacts with the follow button in the UI.
  Follow get chekedFollow {
    if (iFollow) {
      return Follow.following;
    } else if (!iFollow && theyFollow) {
      return Follow.followBack;
    } else {
      return Follow.follow;
    }
  }
}

extension HashtagX on Hashtag {
  bool get trending {
    final lastUsed = lastUsedAt;
    if (lastUsed == null) return false;

    final threshold = now.subtract(const Duration(hours: 24)).toLocal();
    return lastUsed.isAfter(threshold);
  }
}
