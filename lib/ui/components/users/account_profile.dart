import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:semesta/app/functions/tab_delegate.dart';
import 'package:semesta/app/routes/routes.dart';
import 'package:semesta/app/utils/type_def.dart';
import 'package:semesta/core/controllers/post_controller.dart';
import 'package:semesta/ui/components/users/profile_info.dart';
import 'package:semesta/ui/components/global/content_sliver_layer.dart';
import 'package:semesta/ui/components/global/nav_bar_sliver_layer.dart';
import 'package:semesta/ui/widgets/custom_tab_bar.dart';
import 'package:semesta/ui/widgets/custom_text_button.dart';
import 'package:semesta/ui/widgets/follow_button.dart';

class AccountProfile extends StatefulWidget {
  final bool isOwner;
  final String userId;
  final List<Widget> children;
  final PropsCallback<int, void>? onTap;
  const AccountProfile({
    super.key,
    required this.children,
    required this.userId,
    this.onTap,
    this.isOwner = false,
  });

  @override
  State<AccountProfile> createState() => _AccountProfileState();
}

class _AccountProfileState extends State<AccountProfile>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<String> get tabs => [
    'Posts',
    'Replies',
    'Media',
    'Reposts',
    if (widget.isOwner) 'Likes',
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: tabs.length, vsync: this);
  }

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

    final controller = Get.find<PostController>();
    final userCtrl = controller.userCtrl;
    final currentId = controller.currentId;

    return ContentSliverLayer(
      builder: (boxInScrolled) {
        return [
          NavBarSliverLayer(
            pinned: true,
            isForce: boxInScrolled,
            middle: Obx(() {
              final user = userCtrl.dataMapping[widget.userId];
              return Text(
                widget.isOwner ? 'Your profile' : "${user?.name}'s profile",
              );
            }),
            ends: [
              if (widget.isOwner)
                IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.settings),
                  color: colors.outline,
                ),
            ],
          ),

          // Profile info section
          SliverToBoxAdapter(
            child: Obx(() {
              final viewer = userCtrl.dataMapping[currentId];
              final owner = userCtrl.dataMapping[widget.userId];

              if (viewer == null || owner == null) {
                return const SizedBox.shrink();
              }

              final iFollowThem = viewer.isFollowing(owner.id);
              final theyFollowMe = owner.isFollowing(currentId);
              final state = resolveState(iFollowThem, theyFollowMe);

              return ProfileInfo(
                user: owner,
                action: widget.isOwner
                    ? CustomTextButton(
                        label: 'Edit Profile',
                        onPressed: () {},
                        bgColor: colors.secondary,
                        textColor: Colors.white,
                      )
                    : FollowButton(
                        user: owner,
                        state: state,
                        onPressed: () async {
                          await controller.toggleFollow(owner.id, iFollowThem);
                        },
                      ),
                onPreview: () {
                  context.pushNamed(
                    route.avatarPreview.name,
                    pathParameters: {'id': owner.id},
                  );
                },
              );
            }),
          ),

          // Tab bar section
          SliverPersistentHeader(
            pinned: true,
            delegate: TabDelegate(
              CustomTabBar(
                isScrollable: true,
                controller: _tabController,
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
  }
}
