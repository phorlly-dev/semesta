import 'package:flutter/material.dart';
import 'package:semesta/app/routes/custom_route.dart';
import 'package:semesta/app/routes/route_params.dart';

class Routes extends CustomRoute {
  //main pages
  RouteParams get home => RouteParams(path: _convert('home'), name: 'home');
  RouteParams get splash =>
      RouteParams(path: _convert('splash'), name: 'splash');
  RouteParams get auth => RouteParams(path: _convert('auth'), name: 'auth');
  RouteParams get friends =>
      RouteParams(path: _convert('friends'), name: 'friends');
  RouteParams get messenger =>
      RouteParams(path: _convert('messenger'), name: 'messenger');
  RouteParams get watches =>
      RouteParams(path: _convert('watches'), name: 'watches');
  RouteParams get notifications =>
      RouteParams(path: _convert('notifications'), name: 'notifications');
  RouteParams get marketplace =>
      RouteParams(path: _convert('marketplace'), name: 'marketplace');

  //sub pages
  RouteParams get createStory =>
      RouteParams(path: _convert('story-create'), name: 'story.create');
  RouteParams get storyDetail =>
      RouteParams(path: _convert('story-detail'), name: 'story.detail');

  //nav menu
  List<BottomNavigationBarItem> get items => [
    _item(Icons.ondemand_video_outlined, 'TV'),
    _item(Icons.people_outline_rounded, 'People'),
    _item(Icons.home, 'Home'),
    _item(Icons.notifications_none, 'Notify'),
    _item(Icons.menu, 'Menu'),
  ];

  //path menu
  List<String> get paths => [
    watches.path,
    friends.path,
    home.path,
    notifications.path,
    marketplace.path,
  ];

  List<String> get titles => [
    'Semesta',
    watches.name,
    friends.name,
    notifications.name,
    marketplace.name,
  ];

  int getIndexFromLocation(String location) =>
      paths.indexWhere((p) => location.startsWith(p));

  String _convert(String params) => '/$params-page';
  BottomNavigationBarItem _item(IconData icon, [String? label]) =>
      BottomNavigationBarItem(icon: Icon(icon), label: label);
}
