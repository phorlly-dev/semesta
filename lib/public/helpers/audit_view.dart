import 'package:flutter/material.dart';
import 'package:semesta/app/models/author.dart';
import 'package:semesta/app/models/feed.dart';
import 'package:semesta/app/models/reaction.dart';
import 'package:semesta/app/models/stats.dart';
import 'package:semesta/public/helpers/class_helper.dart';

class AuthedView implements HasAttributes {
  final Author author;
  final Reaction action;
  const AuthedView(this.author, this.action);

  @override
  DateTime? get created => action.createdAt;

  @override
  String get currentId => action.id;

  @override
  String get targetId => action.tid;
}

class StatusView with ChangeNotifier {
  final Author author;
  final bool authed;
  bool iFollow;
  final bool theyFollow;

  StatusView(
    this.author, {
    this.authed = false,
    this.iFollow = false,
    this.theyFollow = false,
  });

  StatusView copyWith({
    Author? author,
    Author? actor,
    bool? authed,
    bool? iFollow,
    bool? theyFollow,
  }) => StatusView(
    author ?? this.author,
    authed: authed ?? this.authed,
    iFollow: iFollow ?? this.iFollow,
    theyFollow: theyFollow ?? this.theyFollow,
  );

  void toggle() {
    int v = author.following;
    iFollow = !iFollow;
    author.copyWith(following: iFollow ? v++ : v--);
    notifyListeners();
  }
}

class ActionsView with ChangeNotifier {
  final String pid;
  final Feed feed;
  final ActionTarget target;

  bool reposted;
  bool favorited;
  bool bookmarked;

  int get views => stats.views;
  int get quotes => stats.quotes;
  int get shares => stats.shares;
  int get favorites => stats.likes;
  int get bookmarks => stats.saves;
  int get reposts => stats.reposts;
  int get comments => stats.replies;

  ActionsView(
    this.feed,
    this.target, {
    this.pid = '',
    this.reposted = false,
    this.favorited = false,
    this.bookmarked = false,
  });

  StatsCount get stats => feed.stats;

  void toggleBookmark() {
    int v = stats.saves;
    bookmarked = !bookmarked;
    stats.copyWith(saves: bookmarked ? v++ : v--);
    notifyListeners();
  }

  void toggleFavorite() {
    int v = stats.likes;
    favorited = !favorited;
    stats.copyWith(likes: favorited ? v++ : v--);
    notifyListeners();
  }

  void toggleRepost() {
    int v = stats.reposts;
    reposted = !reposted;
    stats.copyWith(reposts: reposted ? v++ : v--);
    notifyListeners();
  }
}

class RepostView {
  final bool authed;
  final String uid, name;
  const RepostView(this.uid, this.name, [this.authed = false]);
}

class ReferenceView {
  final Feed feed;
  final Author author;
  const ReferenceView(this.feed, this.author);
}
