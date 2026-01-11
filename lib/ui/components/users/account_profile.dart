import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:semesta/app/extensions/controller_extension.dart';
import 'package:semesta/core/views/generic_helper.dart';
import 'package:semesta/app/utils/params.dart';
import 'package:semesta/app/utils/tab_delegate.dart';
import 'package:semesta/app/routes/routes.dart';
import 'package:semesta/app/utils/type_def.dart';
import 'package:semesta/core/views/audit_view.dart';
import 'package:semesta/app/utils/scroll_aware_app_bar.dart';
import 'package:semesta/core/views/utils_helper.dart';
import 'package:semesta/ui/components/users/profile_info.dart';
import 'package:semesta/ui/components/layouts/custom_tab_bar.dart';
import 'package:semesta/ui/widgets/custom_text_button.dart';
import 'package:semesta/ui/widgets/follow_button.dart';
import 'package:semesta/ui/components/layouts/loading_skelenton.dart';

class AccountProfile extends StatefulWidget {
  final bool authed;
  final String uid;
  final int initIndex;
  final List<Widget> children;
  final ValueChanged<int>? onTap;
  final int postCount, mediaCount, favoriteCount;
  const AccountProfile({
    super.key,
    required this.children,
    required this.uid,
    this.onTap,
    this.authed = false,
    this.initIndex = 0,
    this.postCount = 0,
    this.mediaCount = 0,
    this.favoriteCount = 0,
  });

  @override
  State<AccountProfile> createState() => _AccountProfileState();
}

class _AccountProfileState extends State<AccountProfile>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  AsList get _tabs => ['Posts', 'Replies', 'Media', if (widget.authed) 'Likes'];
  CustomTabBar get _tabBar => CustomTabBar(
    controller: _tabController,
    tabs: _tabs.map((tab) => Tab(text: tab)).toList(),
    onTap: widget.onTap,
  );
  CountState get _state => switch (widget.initIndex) {
    2 => countState(widget.mediaCount, KindTab.media),
    3 => countState(widget.favoriteCount, KindTab.favorites),
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
    final route = Routes();
    final colors = Theme.of(context).colorScheme;

    return StreamBuilder<StatusView>(
      stream: actrl.statusStream$(widget.uid),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const LoadingSkelenton();

        final ctx = snapshot.data!;
        return AnimatedBuilder(
          animation: ctx,
          builder: (context, child) {
            return NestedScrollView(
              headerSliverBuilder: (_, innerBox) => [
                ScrollAwareAppBar(
                  builder: (visible) {
                    return SliverAppBar(
                      snap: true,
                      floating: true,
                      centerTitle: true,
                      title: Text(
                        ctx.authed ? 'Your profile' : ctx.author.name,
                      ),
                      actions: [
                        ctx.authed
                            ? IconButton(
                                onPressed: () {},
                                icon: Icon(Icons.settings),
                                color: colors.outline,
                              )
                            : IconButton(
                                onPressed: () {},
                                icon: Icon(Icons.search),
                                color: colors.outline,
                              ),
                      ],
                      toolbarHeight: visible ? kToolbarHeight : 0,
                    );
                  },
                ),

                SliverPersistentHeader(
                  delegate: ProfileHeaderDelegate(
                    expandedHeight: 120,
                    authed: ctx.authed,
                    collapsedHeight: kToolbarHeight,
                    avatarUrl: ctx.author.avatar,
                    coverUrl: ctx.author.banner,
                    onPreview: () async {
                      await context.pushNamed(
                        route.avatar.name,
                        pathParameters: {'id': widget.uid},
                      );
                    },
                  ),
                ),

                // Profile info section
                SliverToBoxAdapter(
                  child: ProfileInfo(
                    state: _state,
                    user: ctx.author,
                    action: ctx.authed
                        ? CustomTextButton(
                            label: 'Edit Profile',
                            onPressed: () {},
                          )
                        : FollowButton(
                            state: resolveState(ctx.iFollow, ctx.theyFollow),
                            onPressed: () async {
                              ctx.toggle();
                              await actrl.toggleFollow(widget.uid, ctx.iFollow);
                            },
                          ),
                  ),
                ),

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
            );
          },
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
