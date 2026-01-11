import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:semesta/app/functions/theme_manager.dart';
import 'package:semesta/core/views/generic_helper.dart';
import 'package:semesta/ui/components/users/user_info.dart';
import 'package:semesta/ui/widgets/action_count.dart';
import 'package:semesta/ui/widgets/animated.dart';
import 'package:semesta/ui/widgets/avatar_animation.dart';

class AppDrawer extends StatelessWidget {
  final String name, userId;
  final String username;
  final String avatarUrl;
  final int following;
  final int followers;

  const AppDrawer({
    super.key,
    required this.name,
    required this.username,
    required this.avatarUrl,
    required this.following,
    required this.followers,
    required this.userId,
  });

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
                      imageUrl: avatarUrl,
                      onTap: () {
                        context.pushNamed(
                          route.profile.name,
                          pathParameters: {'id': userId},
                          queryParameters: {'self': 'true'},
                        );
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
                    context.pushNamed(
                      route.profile.name,
                      pathParameters: {'id': userId},
                      queryParameters: {'self': 'true'},
                    );
                    context.pop();
                  },
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      DisplayName(data: name),
                      Username(data: username, maxChars: 32),
                    ],
                  ),
                ),

                const SizedBox(height: 16),
                Row(
                  spacing: 12,
                  children: [
                    ActionCount(
                      label: 'following',
                      value: following,
                      onTap: () {
                        context.pushNamed(
                          route.friendship.name,
                          pathParameters: {'id': userId},
                          queryParameters: {'name': name, 'index': '1'},
                        );
                        context.pop();
                      },
                    ),
                    ActionCount(
                      label: followers == 1 ? 'follower' : 'followers',
                      value: followers,
                      onTap: () {
                        context.pushNamed(
                          route.friendship.name,
                          pathParameters: {id: userId},
                          queryParameters: {'name': name, 'index': '0'},
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
                  onTap: () {
                    context.pushNamed(
                      route.profile.name,
                      pathParameters: {'id': userId},
                      queryParameters: {'self': 'true'},
                    );
                    context.pop();
                  },
                ),
                _buildItem(Icons.chat_outlined, 'Chat', trailing: 'Beta'),
                _buildItem(
                  Icons.bookmark_border,
                  'Bookmarks',
                  onTap: () {
                    context.pushNamed(
                      route.bookmark.name,
                      pathParameters: {'id': userId},
                    );
                    context.pop();
                  },
                ),
                _buildItem(Icons.list_alt_outlined, 'Lists'),
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
