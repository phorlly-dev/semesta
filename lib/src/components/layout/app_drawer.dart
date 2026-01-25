import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:semesta/app/models/author.dart';
import 'package:semesta/public/extensions/extension.dart';
import 'package:semesta/public/functions/theme_manager.dart';
import 'package:semesta/public/helpers/generic_helper.dart';
import 'package:semesta/public/helpers/utils_helper.dart';
import 'package:semesta/src/components/user/user_info.dart';
import 'package:semesta/src/widgets/sub/action_count.dart';
import 'package:semesta/src/widgets/main/animated.dart';
import 'package:semesta/src/widgets/sub/avatar_animation.dart';

class AppDrawer extends StatelessWidget {
  final Author _user;
  const AppDrawer(this._user, {super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Drawer(
      backgroundColor: theme.scaffoldBackgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(16),
          bottomRight: Radius.circular(16),
        ),
      ),
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
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
                const SizedBox(height: 6),

                Animated(
                  onTap: () async {
                    context.openProfile(_user.id, true);
                    context.pop();
                  },
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [DisplayName(_user.name), Username(_user.uname)],
                  ),
                ),

                const SizedBox(height: 16),
                Row(
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
          ),

          // Menu
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _buildItem(
                  Icons.person_outline,
                  'Profile',
                  onTap: () async {
                    context.openProfile(_user.id, true);
                    context.pop();
                  },
                ),
                _buildItem(Icons.chat_outlined, 'Chat', trailing: 'Beta'),
                _buildItem(
                  Icons.bookmark_border,
                  'Saved',
                  onTap: () async {
                    context.openById(route.bookmark, _user.id);
                    context.pop();
                  },
                ),
                _buildItem(
                  Icons.favorite_border,
                  'Liked',
                  onTap: () async {
                    context.openById(route.favorite, _user.id);
                    context.pop();
                  },
                ),
                const Divider(height: 30),

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
          ListTile(
            leading: IconButton(
              tooltip: 'Theme',
              icon: Icon(
                Theme.of(context).brightness == Brightness.dark
                    ? Icons.light_mode
                    : Icons.dark_mode,
              ),
              onPressed: () {
                context.read<ThemeManager>().toggleTheme(context);
              },
              iconSize: 24,
            ),
            trailing: IconButton(
              tooltip: 'Logout',
              onPressed: () => octrl.logout(),
              color: theme.colorScheme.error,
              icon: const Icon(Icons.logout, size: 24),
            ),
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }

  Widget _buildItem(
    IconData icon,
    String title, {
    String? trailing,
    VoidCallback? onTap,
  }) {
    return ListTile(
      leading: Icon(icon, size: 24),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
      trailing: trailing != null
          ? Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.blue.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                trailing,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          : null,
      onTap: onTap,
    );
  }

  Widget _buildSubItem(String title) {
    return ListTile(title: Text(title), onTap: () {});
  }
}
