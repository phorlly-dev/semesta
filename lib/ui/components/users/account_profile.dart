import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:semesta/app/functions/tab_delegate.dart';
import 'package:semesta/app/routes/routes.dart';
import 'package:semesta/core/controllers/post_controller.dart';
import 'package:semesta/core/controllers/user_controller.dart';
import 'package:semesta/ui/components/users/profile_info.dart';
import 'package:semesta/ui/components/global/content_sliver_layer.dart';
import 'package:semesta/ui/components/global/header_sliver_layer.dart';
import 'package:semesta/ui/widgets/loader.dart';

class AccountProfile extends StatefulWidget {
  final String userId;
  final List<Widget> children;
  final void Function(int idx)? onTap;
  final ScrollController? scroller;

  const AccountProfile({
    super.key,
    required this.children,
    this.scroller,
    required this.userId,
    this.onTap,
  });

  @override
  State<AccountProfile> createState() => _AccountProfileState();
}

class _AccountProfileState extends State<AccountProfile>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _userCtrl = Get.find<UserController>();
  final _postCtrl = Get.find<PostController>();
  List<String> get tabs => [
    'Posts',
    'Replies',
    'Media',
    'Reposts',
    if (_userCtrl.isCurrentUser(widget.userId)) 'Likes',
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: tabs.length, vsync: this);
    _userCtrl.listenToUser(widget.userId);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final route = Routes();

    return Obx(() {
      final isOwner = _userCtrl.isCurrentUser(widget.userId);
      final user = isOwner
          ? _userCtrl.currentUser.value
          : _userCtrl.element.value;
      final isFollow = _postCtrl.currentUser?.isFollowing(widget.userId);

      if (user == null) return Loader();

      return ContentSliverLayer(
        scroller: widget.scroller,
        builder: (inner) {
          return [
            HeaderSliverLayer(
              pinned: true,
              middle: Text(isOwner ? 'Your profile' : "${user.name}'s profile"),
              ends: [
                if (isOwner)
                  IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.settings),
                    color: colors.outline,
                  ),
              ],
            ),

            // Profile info section
            SliverToBoxAdapter(
              child: ProfileInfo(
                user: user,
                isFollow: isFollow!.value,
                isOwner: isOwner,
                onFollow: () async {
                  await _postCtrl.toggleFollow(user.id, isFollow.value);
                  isFollow.toggle();
                },
                onPreview: () {
                  context.pushNamed(
                    route.avatarPreview.name,
                    pathParameters: {'id': user.id},
                    queryParameters: {'self': isOwner.toString()},
                  );
                },
              ),
            ),

            // Tab bar section
            SliverPersistentHeader(
              pinned: true,
              delegate: TabDelegate(
                TabBar(
                  isScrollable: true,
                  controller: _tabController,
                  labelColor: colors.scrim,
                  unselectedLabelColor: colors.secondary,
                  indicatorColor: colors.primary,
                  tabs: tabs.map((tab) => Tab(text: tab)).toList(),
                  onTap: widget.onTap,
                  tabAlignment: TabAlignment.center,
                ),
              ),
            ),
          ];
        },

        // Body scrollable content
        content: TabBarView(
          controller: _tabController,
          children: widget.children,
        ),
      );
    });
  }
}
