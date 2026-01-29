import 'package:flutter/material.dart';
import 'package:semesta/app/models/author.dart';
import 'package:semesta/app/models/feed.dart';
import 'package:semesta/app/models/reaction.dart';
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

  StatusView({
    this.actor,
    required this.author,
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
    author: author ?? this.author,
    actor: actor ?? this.actor,
    authed: authed ?? this.authed,
    iFollow: iFollow ?? this.iFollow,
    theyFollow: theyFollow ?? this.theyFollow,
  );

  void toggle() {
    iFollow = !iFollow;
    notifyListeners();
  }
}

class ActionsView with ChangeNotifier {
  final String pid;
  final Feed feed;
  final ActionTarget target;

  bool favorited;
  bool bookmarked;
  bool reposted;

  int favorites;
  int bookmarks;
  int reposts;

  final int quotes;
  final int views;
  final int comments;
  final int shares;

  ActionsView({
    required this.pid,
    required this.feed,
    required this.target,
    this.views = 0,
    this.shares = 0,
    this.quotes = 0,
    this.reposts = 0,
    this.comments = 0,
    this.favorites = 0,
    this.bookmarks = 0,
    this.reposted = false,
    this.favorited = false,
    this.bookmarked = false,
  });

  void toggleBookmark() {
    bookmarked = !bookmarked;
    bookmarked ? bookmarks++ : bookmarks--;
    notifyListeners();
  }

  void toggleFavorite() {
    favorited = !favorited;
    favorited ? favorites++ : favorites--;
    notifyListeners();
  }

  void toggleRepost() {
    reposted = !reposted;
    reposted ? reposts++ : reposts--;
    notifyListeners();
  }
}

class RepostView {
  final bool authed;
  final String uid, name;
  const RepostView({this.authed = false, this.uid = '', this.name = ''});
}
