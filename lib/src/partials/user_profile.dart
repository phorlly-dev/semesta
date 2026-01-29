import 'package:flutter/material.dart';
import 'package:semesta/public/extensions/controller_extension.dart';
import 'package:semesta/public/extensions/extension.dart';
import 'package:semesta/public/helpers/generic_helper.dart';
import 'package:semesta/public/helpers/utils_helper.dart';
import 'package:semesta/public/utils/params.dart';
import 'package:semesta/public/utils/scroll_aware_app_bar.dart';
import 'package:semesta/public/utils/tab_delegate.dart';
import 'package:semesta/public/utils/type_def.dart';
import 'package:semesta/src/components/user/profile_header_delegate.dart';
import 'package:semesta/src/components/layout/custom_tab_bar.dart';
import 'package:semesta/src/components/global/loading_skelenton.dart';
import 'package:semesta/src/components/user/profile_info.dart';

class UserProfile extends StatefulWidget {
  final bool authed;
  final String uid;
  final int initIndex;
  final List<Widget> children;
  final ValueChanged<int>? onTap;
  final int postCount, mediaCount;
  const UserProfile({
    super.key,
    required this.children,
    required this.uid,
    this.onTap,
    this.authed = false,
    this.initIndex = 0,
    this.postCount = 0,
    this.mediaCount = 0,
  });

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  AsList get _tabs => ['Posts', 'Replies', 'Media'];
  CustomTabBar get _tabBar => CustomTabBar(
    controller: _tabController,
    tabs: _tabs.map((tab) => Tab(text: tab)).toList(),
    onTap: widget.onTap,
  );
  CountState get _state => switch (widget.initIndex) {
    2 => countState(widget.mediaCount, FeedKind.media),
    _ => countState(widget.postCount),
  };

  @override
  void initState() {
    _tabController = TabController(
      vsync: this,
      length: _tabs.length,
      initialIndex: widget.initIndex,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: actrl.status$(widget.uid),
      builder: (_, snapshot) {
        if (!snapshot.hasData) return const LoadingSkelenton();

        final state = snapshot.data!;
        return AnimatedBuilder(
          animation: state,
          builder: (_, child) => NestedScrollView(
            headerSliverBuilder: (_, innerBox) => [
              ScrollAwareAppBar(
                (visible) => SliverAppBar(
                  snap: true,
                  floating: true,
                  centerTitle: true,
                  title: Text(
                    state.authed ? 'Your profile' : state.author.name,
                  ),
                  actions: [
                    state.authed
                        ? IconButton(
                            onPressed: () {},
                            icon: Icon(Icons.settings),
                            color: context.outlineColor,
                          )
                        : IconButton(
                            onPressed: () {},
                            icon: Icon(Icons.search),
                            color: context.outlineColor,
                          ),
                  ],
                  elevation: 0,
                  scrolledUnderElevation: 0,
                  toolbarHeight: visible ? kToolbarHeight : 0,
                  backgroundColor: context.defaultColor,
                  surfaceTintColor: Colors.transparent,
                ),
              ),

              SliverPersistentHeader(
                delegate: ProfileHeaderDelegate(
                  expandedHeight: 120,
                  authed: state.authed,
                  collapsedHeight: kToolbarHeight,
                  avatarUrl: state.author.avatar,
                  coverUrl: state.author.banner,
                  onPreview: () async {
                    await context.openById(route.avatar, widget.uid);
                  },
                ),
              ),

              // Profile info section
              SliverToBoxAdapter(child: ProfileInfo(_state, state)),

              // Tab bar section
              SliverPersistentHeader(
                pinned: true,
                delegate: TabDelegate(_tabBar),
              ),
            ],
            body: TabBarView(
              controller: _tabController,
              children: widget.children,
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}
