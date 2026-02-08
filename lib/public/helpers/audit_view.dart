import 'package:flutter/material.dart';
import 'package:semesta/app/models/author.dart';
import 'package:semesta/app/models/feed.dart';
import 'package:semesta/app/models/reaction.dart';
import 'package:semesta/app/models/stats_count.dart';
import 'package:semesta/public/helpers/class_helper.dart';

class AuthedView implements HasAttributes {
  final Author author;
  final Reaction action;
  const AuthedView(this.author, this.action);

  @override
  DateTime? get created => action.createdAt;

  @override
  String get currentId => action.currentId;

  @override
  String get targetId => action.targetId;
}

class StatusView with ChangeNotifier {
  final Author author;
  final Author? actor;
  final bool authed;
  bool iFollow;
  final bool theyFollow;

  StatusView(
    this.author, {
    this.actor,
    this.authed = false,
    this.iFollow = false,
    this.theyFollow = false,
  });

  StatusView copy({
    Author? author,
    Author? actor,
    bool? authed,
    bool? iFollow,
    bool? theyFollow,
  }) => StatusView(
    author ?? this.author,
    actor: actor ?? this.actor,
    authed: authed ?? this.authed,
    iFollow: iFollow ?? this.iFollow,
    theyFollow: theyFollow ?? this.theyFollow,
  );

  void toggle() {
    int v = author.following;
    iFollow = !iFollow;
    author.copy(following: iFollow ? v++ : v--);
    notifyListeners();
  }
}

class ActionsView with ChangeNotifier {
  final String pid;
  final Feed feed;
  final StatsCount stats;
  final ActionTarget target;

  bool reposted;
  bool favorited;
  bool bookmarked;

  int get views => stats.viewed;
  int get quotes => stats.quoted;
  int get shares => stats.shared;
  int get favorites => stats.liked;
  int get bookmarks => stats.saved;
  int get reposts => stats.reposted;
  int get comments => stats.replied;

  ActionsView(
    this.feed,
    this.stats,
    this.target, {
    this.pid = '',
    this.reposted = false,
    this.favorited = false,
    this.bookmarked = false,
  });

  void toggleBookmark() {
    int v = stats.saved;
    bookmarked = !bookmarked;
    stats.copy(saved: bookmarked ? v++ : v--);
    notifyListeners();
  }

  void toggleFavorite() {
    int v = stats.liked;
    favorited = !favorited;
    stats.copy(liked: favorited ? v++ : v--);
    notifyListeners();
  }

  void toggleRepost() {
    int v = stats.reposted;
    reposted = !reposted;
    stats.copy(reposted: reposted ? v++ : v--);
    notifyListeners();
  }
}

class RepostView {
  final bool authed;
  final String uid, name;
  const RepostView(this.uid, this.name, [this.authed = false]);
}
