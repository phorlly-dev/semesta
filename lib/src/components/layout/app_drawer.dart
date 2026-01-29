import 'package:flutter/material.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:go_router/go_router.dart';
import 'package:semesta/app/models/author.dart';
import 'package:semesta/public/extensions/extension.dart';
import 'package:semesta/public/helpers/generic_helper.dart';
import 'package:semesta/public/helpers/utils_helper.dart';
import 'package:semesta/src/components/user/user_info.dart';
import 'package:semesta/src/widgets/main/option_button.dart';
import 'package:semesta/src/widgets/sub/action_count.dart';
import 'package:semesta/src/widgets/main/animated.dart';
import 'package:semesta/src/widgets/sub/avatar_animation.dart';
import 'package:semesta/src/widgets/sub/break_section.dart';
import 'package:semesta/src/widgets/sub/direction_x.dart';
import 'package:semesta/src/widgets/sub/direction_y.dart';

class AppDrawer extends StatelessWidget {
  final Author _user;
  const AppDrawer(this._user, {super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: context.defaultColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(16),
          bottomRight: Radius.circular(16),
        ),
      ),
      child: DirectionY(
        children: [
          DirectionY(
            margin: EdgeInsets.only(left: 24, right: 12, top: 16),
            children: [
              // Header
              DirectionX(
                children: [
                  AvatarAnimation(
                    _user.avatar,
                    onTap: () async {
                      context.openProfile(_user.id, true);
                      context.pop();
                    },
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.menu_open_rounded),
                    onPressed: () {
                      context.pop();
                    },
                  ),
                ],
              ),

              Animated(
                onTap: () async {
                  context.openProfile(_user.id, true);
                  context.pop();
                },
                child: DirectionY(
                  mainAxisSize: MainAxisSize.min,
                  children: [DisplayName(_user.name), Username(_user.uname)],
                ),
              ),

              const SizedBox(height: 8),
              DirectionX(
                spacing: 12,
                children: [
                  ActionCount(
                    _user.following,
                    kind: FeedKind.following,
                    onTap: () async {
                      context.openFollow(
                        route.friendship,
                        _user.id,
                        idx: 1,
                        name: _user.name,
                      );
                      context.pop();
                    },
                  ),
                  ActionCount(
                    _user.follower,
                    kind: FeedKind.follower,
                    onTap: () async {
                      context.openFollow(
                        route.friendship,
                        _user.id,
                        idx: 0,
                        name: _user.name,
                      );
                      context.pop();
                    },
                  ),
                ],
              ),
            ],
          ),

          const BreakSection(height: 24),

          // Menu
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                OptionButton(
                  'Profile',
                  icon: Icons.person_outline,
                  onTap: () async {
                    await context.openProfile(_user.id, true);
                  },
                ),

                OptionButton('Chat', icon: Icons.chat_outlined),
                OptionButton(
                  'Saved',
                  icon: Icons.bookmark_border,
                  onTap: () async {
                    await context.openById(route.bookmark, _user.id);
                  },
                ),
                OptionButton(
                  'Liked',
                  icon: Icons.favorite_border,
                  onTap: () async {
                    await context.openById(route.favorite, _user.id);
                  },
                ),

                const BreakSection(),

                ExpansionTile(
                  title: const Text(
                    'Settings & Support',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  childrenPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 4,
                  ),
                  children: [
                    _buildSubItem('Settings'),
                    _buildSubItem('Help Center'),
                    _buildSubItem('About App'),
                  ],
                ),
              ],
            ),
          ),

          // Bottom row
          DirectionX(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                tooltip: 'Theme',
                icon: Icon(
                  context.isDarkMode ? Icons.light_mode : Icons.dark_mode,
                ),
                onPressed: () => context.toggleTheme,
                iconSize: 24,
              ),

              IconButton(
                tooltip: 'Logout',
                onPressed: () => octrl.logout(),
                color: context.colors.error,
                icon: const Icon(Icons.logout, size: 24),
              ),
            ],
          ),

          const SizedBox(height: 12),
        ],
      ),
    );
  }

  Widget _buildSubItem(String title, {VoidCallback? onTap}) {
    return ListTile(title: Text(title), onTap: onTap);
  }
}
