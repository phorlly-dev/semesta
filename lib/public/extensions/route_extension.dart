import 'package:go_router/go_router.dart';
import 'package:semesta/app/models/reaction.dart';
import 'package:semesta/public/helpers/feed_view.dart';

extension GoRouterStateX on GoRouterState {
  String pathOrQuery(String key, [bool quering = false]) {
    var params = pathParameters[key];

    if (quering) params = uri.queryParameters[key];
    if (params == null) {
      throw StateError('Invalid params key: $params');
    }

    return params;
  }
}

extension FeedKindX on FeedKind {
  ReactionType get type {
    return switch (this) {
      FeedKind.likes => ReactionType.like,
      FeedKind.posts => ReactionType.post,
      FeedKind.reposts => ReactionType.repost,
      FeedKind.quotes => ReactionType.quote,
      FeedKind.replies => ReactionType.reply,
      FeedKind.saves => ReactionType.save,
      FeedKind.media => ReactionType.media,
      FeedKind.views => ReactionType.view,
      FeedKind.shares => ReactionType.share,
      FeedKind.following => ReactionType.following,
      FeedKind.followers => ReactionType.follower,
    };
  }
}

extension ReactionTypeX on ReactionType {
  FeedKind? get kind {
    return switch (this) {
      ReactionType.post => FeedKind.posts,
      ReactionType.media => FeedKind.media,
      ReactionType.like => FeedKind.likes,
      ReactionType.view => FeedKind.views,
      ReactionType.reply => FeedKind.replies,
      ReactionType.repost => FeedKind.reposts,
      ReactionType.quote => FeedKind.quotes,
      ReactionType.save => FeedKind.saves,
      ReactionType.share => FeedKind.shares,
      ReactionType.follower => FeedKind.followers,
      ReactionType.following => FeedKind.following,
    };
  }
}
