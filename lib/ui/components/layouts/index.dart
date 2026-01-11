import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:semesta/app/extensions/controller_extension.dart';
import 'package:semesta/core/views/generic_helper.dart';
import 'package:semesta/ui/components/layouts/_layout_page.dart';
import 'package:semesta/ui/components/layouts/app_drawer.dart';

class AppLayout extends StatelessWidget {
  final Widget child;
  const AppLayout({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final location = GoRouterState.of(context).matchedLocation;
    final index = route.getIndexFromLocation(location);

    return Obx(() {
      final user = pctrl.currentUser;
      final isVisible = dctrl.isVisible.value;
      final curIdx = dctrl.currentIndex.value;
      final curScroller = dctrl.scrollControllers[curIdx];

      return LayoutPage(
        menu: AppDrawer(
          userId: user.id,
          name: user.name,
          username: user.uname,
          avatarUrl: user.avatar,
          following: user.followingCount,
          followers: user.followersCount,
        ),
        content: child,
        footer: AnimatedSlide(
          duration: const Duration(milliseconds: 250),
          offset: Offset.zero,
          child: isVisible
              ? BottomNavigationBar(
                  elevation: 6,
                  currentIndex: index,
                  backgroundColor:
                      theme.bottomNavigationBarTheme.backgroundColor ??
                      theme.scaffoldBackgroundColor,
                  selectedItemColor: theme.colorScheme.primary,
                  unselectedItemColor: theme.iconTheme.color?.withValues(
                    alpha: 0.6,
                  ),
                  onTap: (idx) async {
                    if (curScroller.hasClients && idx == index) {
                      dctrl.jump;

                      switch (idx) {
                        case 0:
                          break;
                        default:
                          if (!pctrl.anyLoading) {
                            if (curIdx == 0) {
                              await pctrl.refreshPost();
                            } else {
                              await pctrl.refreshFollowing();
                            }
                          }
                      }
                    }

                    if (context.mounted) context.go(route.paths[idx]);
                  },
                  items: route.items,
                  type: BottomNavigationBarType.shifting,
                )
              : null,
        ),
        button: index == 2
            ? AnimatedSlide(
                duration: const Duration(milliseconds: 250),
                offset: isVisible ? Offset.zero : const Offset(0, 2),
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 250),
                  opacity: isVisible ? 1 : 0,
                  child: FloatingActionButton(
                    onPressed: () => context.push(route.create.path),
                    backgroundColor: const Color(0xFF1D9BF0),
                    shape: const CircleBorder(),
                    elevation: 4,
                    child: const Icon(Icons.add, color: Colors.white, size: 28),
                  ),
                ),
              )
            : null,
      );
    });
  }
}
