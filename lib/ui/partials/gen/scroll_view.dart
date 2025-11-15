import 'package:flutter/material.dart';

class AppScrollView extends StatelessWidget {
  final bool hasNav;
  final List<Widget> children;
  final ScrollController? scroller;
  const AppScrollView({
    super.key,
    this.hasNav = false,
    required this.children,
    this.scroller,
  });

  @override
  Widget build(BuildContext context) {
    return NestedScrollView(
      controller: scroller,
      headerSliverBuilder: (context, innerScrolled) => [
        if (hasNav)
          SliverAppBar(
            // pinned: true,
            floating: true,
            title: const Text(
              'Semesta',
              style: TextStyle(
                color: Colors.blue,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            centerTitle: false,
            backgroundColor: Colors.white,
            actions: [
              IconButton(
                icon: const Icon(Icons.search, color: Colors.black),
                onPressed: () {},
              ),
              // IconButton(
              //   icon: const Icon(Icons.menu, color: Colors.black),
              //   onPressed: () {},
              // ),
            ],
          ),
      ],
      clipBehavior: Clip.antiAliasWithSaveLayer,
      body: ListView(children: children),
    );
  }
}
