import 'package:flutter/material.dart';

import 'package:semesta/app/models/feed.dart';
import 'package:semesta/public/extensions/context_extension.dart';
import 'package:semesta/public/helpers/feed_view.dart';
import 'package:semesta/public/utils/type_def.dart';

class VisibleToPost {
  final String label;
  final IconData icon;
  final Visible option;
  final VoidCallback? onTap;
  const VisibleToPost._(this.label, this.icon, this.option, this.onTap);

  factory VisibleToPost.public([ValueChanged<Visible>? onChanged]) {
    return VisibleToPost._(
      'Everyone',
      Icons.public,
      Visible.everyone,
      () => onChanged?.call(Visible.everyone),
    );
  }

  factory VisibleToPost.verified([ValueChanged<Visible>? onChanged]) {
    return VisibleToPost._(
      'Verified accounts',
      Icons.verified,
      Visible.verified,
      () => onChanged?.call(Visible.verified),
    );
  }

  factory VisibleToPost.following([ValueChanged<Visible>? onChanged]) {
    return VisibleToPost._(
      'Accounts you follow',
      Icons.people_alt_outlined,
      Visible.following,
      () => onChanged?.call(Visible.following),
    );
  }

  factory VisibleToPost.mentioned([ValueChanged<Visible>? onChanged]) {
    return VisibleToPost._(
      'Only accounts you mention',
      Icons.alternate_email_outlined,
      Visible.mentioned,
      () => onChanged?.call(Visible.mentioned),
    );
  }

  factory VisibleToPost.render(Visible visible) => switch (visible) {
    Visible.everyone => VisibleToPost.public(),
    Visible.verified => VisibleToPost.verified(),
    Visible.following => VisibleToPost.following(),
    Visible.mentioned => VisibleToPost.mentioned(),
  };
}

class CountState {
  final String key;
  final int value;
  final FeedKind kind;
  const CountState._(this.key, this.value, this.kind);

  factory CountState.render(
    int value, [
    FeedKind kind = FeedKind.posts,
  ]) => switch (kind) {
    FeedKind.likes => CountState._(value == 1 ? 'Like' : 'Likes', value, kind),
    FeedKind.views => CountState._(value == 1 ? 'View' : 'Views', value, kind),
    FeedKind.following => CountState._('Following', value, kind),
    FeedKind.followers => CountState._(
      value == 1 ? 'Follower' : 'Followers',
      value,
      kind,
    ),
    FeedKind.quotes => CountState._(
      value == 1 ? 'Quote' : 'Quotes',
      value,
      kind,
    ),
    FeedKind.reposts => CountState._(
      value == 1 ? 'Repost' : 'Reposts',
      value,
      kind,
    ),
    FeedKind.saves => CountState._(value == 1 ? 'Save' : 'Saves', value, kind),
    FeedKind.shares => CountState._(
      value == 1 ? 'Share' : 'Shares',
      value,
      kind,
    ),
    FeedKind.media => CountState._('Media', value, FeedKind.media),
    FeedKind.posts => CountState._(value == 1 ? 'Post' : 'Posts', value, kind),
    FeedKind.replies => CountState._(
      value == 1 ? 'Reply' : 'Replies',
      value,
      kind,
    ),
  };
}

class RouteNode {
  final String path;
  final String name;
  const RouteNode(this.path, this.name);

  RouteNode child(String subpath, String subname) {
    assert(!subpath.startsWith('/'), 'Child route must be relative: $subpath');

    return RouteNode('$path/$subpath', '$name.$subname');
  }
}

enum MediaSourceType { network, file, asset }

class MediaSource {
  final String path;
  final MediaSourceType type;
  const MediaSource._(this.type, this.path);

  factory MediaSource.network(String url) {
    return MediaSource._(MediaSourceType.network, url);
  }

  factory MediaSource.file(String filePath) {
    return MediaSource._(MediaSourceType.file, filePath);
  }

  factory MediaSource.asset(String assetPath) {
    return MediaSource._(MediaSourceType.asset, assetPath);
  }
}

enum Follow { follow, followBack, following }

class FollowState {
  final Follow type;
  final String label;
  final Color background, foreground;
  const FollowState._(this.type, this.label, this.background, this.foreground);

  factory FollowState.render(BuildContext context, Follow type) {
    return switch (type) {
      Follow.follow => FollowState._(
        Follow.follow,
        'Follow',
        context.primaryColor,
        context.colors.onPrimary,
      ),
      Follow.followBack => FollowState._(
        Follow.follow,
        'Follow back',
        context.secondaryColor,
        context.defaultColor,
      ),
      Follow.following => FollowState._(
        Follow.follow,
        'Following',
        Colors.transparent,
        context.primaryColor,
      ),
    };
  }
}

class ProfileMeta {
  final String location;
  final String website;
  final DateTime? birthdate;
  final DateTime? joined;
  const ProfileMeta(this.location, this.website, {this.birthdate, this.joined});
}

class LocationSuggestion {
  final String primary; // e.g. "Los Angeles"
  final String secondary; // e.g. "CA, United States"
  final String? placeId; // optional (Google / Mapbox)
  const LocationSuggestion(this.primary, this.secondary, {this.placeId});
}

class ParsedText {
  final AsList hashtags;
  final AsList mentions;
  const ParsedText(this.hashtags, this.mentions);
}
