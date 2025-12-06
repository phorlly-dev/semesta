import 'package:flutter/material.dart';

class FunctionHelper {
  //nav menu
  List<BottomNavigationBarItem> get items => [
    item(Icons.search, 'Explore'),
    item(Icons.ondemand_video_rounded, 'Reels'),
    item(Icons.home, 'Home'),
    item(Icons.notifications_none, 'Notifications'),
    item(Icons.email_outlined, 'Messages'),
  ];

  //helper
  String convert(String params) => '/$params-page';
  BottomNavigationBarItem item(IconData icon, [String? label]) =>
      BottomNavigationBarItem(icon: Icon(icon), label: label);
}
