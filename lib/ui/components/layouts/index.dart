import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:semesta/app/extensions/controller_extension.dart';
import 'package:semesta/app/routes/routes.dart';
import 'package:semesta/app/utils/scroll_helper.dart';
import 'package:semesta/core/controllers/post_controller.dart';
import 'package:semesta/ui/components/layouts/_layout_page.dart';
import 'package:semesta/ui/components/layouts/side_bar_layer.dart';

class AppLayout extends StatelessWidget {
  final Widget child;
  const AppLayout({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final routes = Routes();
    final theme = Theme.of(context);
    final location = GoRouterState.of(context).matchedLocation;
    final index = routes.getIndexFromLocation(location);
    final scroller = Get.find<ScrollHelper>();
    final controller = Get.find<PostController>();

    return Obx(() {
      final user = controller.currentUser;
      final isVisible = scroller.isVisible.value;
      final curIdx = scroller.currentIndex.value;
      final curScroller = scroller.scrollControllers[curIdx];

      return LayoutPage(
        menu: SideBarLayer(
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
                      scroller.jump;

                      switch (idx) {
                        case 0:
                          break;
                        default:
                          if (!controller.isAnyLoading) {
                            if (curIdx == 0) {
                              await controller.refreshPost();
                            } else {
                              await controller.refreshFollowing();
                            }
                          }
                      }
                    }

                    if (context.mounted) context.go(routes.paths[idx]);
                  },
                  items: routes.items,
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
                    onPressed: () => context.push(Routes().createPost.path),
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
