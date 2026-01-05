import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:semesta/app/extensions/controller_extension.dart';
import 'package:semesta/app/utils/params.dart';
import 'package:semesta/app/utils/tab_delegate.dart';
import 'package:semesta/app/routes/routes.dart';
import 'package:semesta/app/utils/type_def.dart';
import 'package:semesta/core/controllers/action_controller.dart';
import 'package:semesta/core/views/audit_view.dart';
import 'package:semesta/ui/components/users/profile_info.dart';
import 'package:semesta/ui/widgets/custom_tab_bar.dart';
import 'package:semesta/ui/widgets/custom_text_button.dart';
import 'package:semesta/ui/widgets/follow_button.dart';
import 'package:semesta/ui/components/layouts/loading_skelenton.dart';

class AccountProfile extends StatefulWidget {
  final bool authed;
  final String uid;
  final CountState state;
  final int initIndex;
  final List<Widget> children;
  final PropsCallback<int, void>? onTap;
  const AccountProfile({
    super.key,
    required this.children,
    required this.uid,
    this.onTap,
    this.authed = false,
    this.initIndex = 0,
    required this.state,
  });

  @override
  State<AccountProfile> createState() => _AccountProfileState();
}

class _AccountProfileState extends State<AccountProfile>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _controller = Get.find<ActionController>();
  AsList get _tabs => ['Posts', 'Replies', 'Media', if (widget.authed) 'Likes'];

  @override
  void initState() {
    _tabController = TabController(
      length: _tabs.length,
      vsync: this,
      initialIndex: widget.initIndex,
    );
    super.initState();
  }

  CustomTabBar get _tabBar => CustomTabBar(
    controller: _tabController,
    tabs: _tabs.map((tab) => Tab(text: tab)).toList(),
    onTap: widget.onTap,
  );

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final route = Routes();
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return StreamBuilder<StatusView>(
      stream: _controller.statusStream$(widget.uid),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const LoadingSkelenton();

        final ctx = snapshot.data!;
        return NestedScrollView(
          headerSliverBuilder: (_, innerBox) => [
            SliverAppBar(
              centerTitle: true,
              title: Text(ctx.authed ? 'Your profile' : ctx.author.name),
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
            ),

            // Profile info section
            SliverToBoxAdapter(
              child: ProfileInfo(
                state: widget.state,
                user: ctx.author,
                action: ctx.authed
                    ? CustomTextButton(
                        label: 'Edit Profile',
                        onPressed: () {},
                        bgColor: colors.secondary,
                        textColor: Colors.white,
                      )
                    : FollowButton(
                        state: resolveState(ctx.iFollow, ctx.theyFollow),
                        onPressed: () async {
                          await _controller.toggleFollow(
                            widget.uid,
                            ctx.iFollow,
                          );
                        },
                      ),
                onPreview: () async {
                  await context.pushNamed(
                    route.avatarPreview.name,
                    pathParameters: {'id': widget.uid},
                  );
                },
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
  }
}
