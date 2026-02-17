import 'package:flutter/material.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:go_router/go_router.dart';
import 'package:semesta/app/models/author.dart';
import 'package:semesta/public/extensions/context_extension.dart';
import 'package:semesta/public/helpers/feed_view.dart';
import 'package:semesta/public/helpers/generic_helper.dart';
import 'package:semesta/public/helpers/params_helper.dart';
import 'package:semesta/src/components/info/data_helper.dart';
import 'package:semesta/src/widgets/main/option_button.dart';
import 'package:semesta/src/widgets/sub/animated_count.dart';
import 'package:semesta/src/widgets/main/animated.dart';
import 'package:semesta/src/widgets/sub/animated_avatar.dart';
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
          _info(context),

          const BreakSection(height: 24),

          // Menu
          _menu(context),

          // Bottom row
          _mode(context),

          const SizedBox(height: 12),
        ],
      ),
    );
  }

  Widget _info(BuildContext context) => DirectionY(
    margin: EdgeInsets.only(left: 24, right: 12, top: 16),
    children: [
      // Header
      DirectionX(
        children: [
          AnimatedAvatar(
            MediaSource.network(_user.media.url),
            padding: EdgeInsets.only(top: 6),
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
        child: DirectionY(
          size: MainAxisSize.min,
          children: [DisplayName(_user.name), Username(_user.uname)],
        ),
        onTap: () async {
          context.openProfile(_user.id, true);
          context.pop();
        },
      ),

      const SizedBox(height: 8),
      DirectionX(
        spacing: 12,
        children: [
          AnimatedCount(
            _user.following,
            kind: FeedKind.following,
            onTap: () {
              context.openFollow(
                routes.friendship,
                _user.id,
                idx: 1,
                name: _user.name,
              );
              context.pop();
            },
          ),

          AnimatedCount(
            _user.followers,
            kind: FeedKind.followers,
            onTap: () {
              context.openFollow(
                routes.friendship,
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
  );

  Widget _menu(BuildContext context) {
    final icon = 24.0;
    final text = context.texts.titleMedium?.copyWith(
      fontWeight: FontWeight.bold,
    );

    return Expanded(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          OptionButton(
            'Profile',
            icon: Icons.person_outline,
            style: text,
            sizeIcon: icon,
            onTap: () async {
              await context.openProfile(_user.id, true);
            },
          ),

          OptionButton(
            'Chat',
            style: text,
            sizeIcon: icon,
            icon: Icons.chat_outlined,
          ),
          OptionButton(
            'Saved',
            style: text,
            sizeIcon: icon,
            icon: Icons.bookmark_border,
            onTap: () async {
              await context.openById(routes.bookmark, _user.id);
            },
          ),
          OptionButton(
            'Liked',
            style: text,
            sizeIcon: icon,
            icon: Icons.favorite_border,
            onTap: () async {
              await context.openById(routes.favorite, _user.id);
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
    );
  }

  Widget _mode(BuildContext context) => DirectionX(
    padding: const EdgeInsets.symmetric(horizontal: 12),
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      IconButton(
        tooltip: 'Theme',
        icon: Icon(context.isDarkMode ? Icons.light_mode : Icons.dark_mode),
        onPressed: context.toggleTheme,
        iconSize: 24,
      ),

      IconButton(
        tooltip: 'Logout',
        onPressed: octrl.logout,
        color: context.errorColor,
        icon: const Icon(Icons.logout, size: 24),
      ),
    ],
  );

  Widget _buildSubItem(String title, {VoidCallback? onTap}) {
    return ListTile(title: Text(title), onTap: onTap);
  }
}
