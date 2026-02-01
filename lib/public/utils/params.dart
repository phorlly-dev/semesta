import 'package:flutter/material.dart';
import 'package:semesta/app/models/feed.dart';
import 'package:semesta/public/extensions/extension.dart';
import 'package:semesta/public/helpers/utils_helper.dart';

class VisibleToPost {
  final String label;
  final IconData icon;
  final VoidCallback? onTap;
  final Visible option;
  const VisibleToPost._({
    this.onTap,
    required this.icon,
    required this.label,
    required this.option,
  });

  factory VisibleToPost.public([ValueChanged<Visible>? onChanged]) {
    final v = Visible.everyone;
    return VisibleToPost._(
      option: v,
      label: 'Everyone',
      icon: Icons.public,
      onTap: () => onChanged?.call(v),
    );
  }

  factory VisibleToPost.verified([ValueChanged<Visible>? onChanged]) {
    final v = Visible.verified;
    return VisibleToPost._(
      option: v,
      icon: Icons.verified,
      label: 'Verified accounts',
      onTap: () => onChanged?.call(v),
    );
  }

  factory VisibleToPost.following([ValueChanged<Visible>? onChanged]) {
    final v = Visible.following;
    return VisibleToPost._(
      option: v,
      label: 'Accounts you follow',
      icon: Icons.people_alt_outlined,
      onTap: () => onChanged?.call(v),
    );
  }

  factory VisibleToPost.mentioned([ValueChanged<Visible>? onChanged]) {
    final v = Visible.mentioned;
    return VisibleToPost._(
      option: v,
      label: 'Only accounts you mention',
      icon: Icons.alternate_email_outlined,
      onTap: () => onChanged?.call(v),
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
    FeedKind kind = FeedKind.posted,
  ]) => switch (kind) {
    FeedKind.liked => CountState._(value == 1 ? 'Like' : 'Likes', value, kind),
    FeedKind.viewed => CountState._(value == 1 ? 'View' : 'Views', value, kind),
    FeedKind.following => CountState._('Following', value, kind),
    FeedKind.follower => CountState._(
      value == 1 ? 'Follower' : 'Followers',
      value,
      kind,
    ),
    FeedKind.quoted => CountState._(
      value == 1 ? 'Quote' : 'Quotes',
      value,
      kind,
    ),
    FeedKind.reposted => CountState._(
      value == 1 ? 'Repost' : 'Reposts',
      value,
      kind,
    ),
    FeedKind.saved => CountState._(value == 1 ? 'Save' : 'Saves', value, kind),
    FeedKind.shared => CountState._(
      value == 1 ? 'Share' : 'Shares',
      value,
      kind,
    ),
    FeedKind.media => CountState._('Media', value, FeedKind.media),
    FeedKind.posted => CountState._(value == 1 ? 'Post' : 'Posts', value, kind),
    FeedKind.replied => CountState._(
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
