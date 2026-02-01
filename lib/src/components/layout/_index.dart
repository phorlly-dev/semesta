import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:semesta/public/extensions/controller_extension.dart';
import 'package:semesta/public/extensions/extension.dart';
import 'package:semesta/public/helpers/generic_helper.dart';
import 'package:semesta/src/components/layout/_page.dart';
import 'package:semesta/src/components/layout/drawer.dart';

class AppLayout extends StatelessWidget {
  final Widget _child;
  const AppLayout(this._child, {super.key});

  @override
  Widget build(BuildContext context) {
    final index = route.getIndexFromLocation(context.location);

    return Obx(() {
      final user = pctrl.currentUser;
      final visible = dctrl.visible.value;
      final curIdx = dctrl.index.value;
      final curScroller = dctrl.controllers[curIdx];

      return PageLayout(
        menu: AppDrawer(user),
        content: _child,
        footer: AnimatedSlide(
          duration: const Duration(milliseconds: 260),
          offset: Offset.zero,
          child: visible
              ? BottomNavigationBar(
                  elevation: 6,
                  currentIndex: index,
                  selectedItemColor: context.primaryColor,
                  backgroundColor: context.navigatColor ?? context.defaultColor,
                  unselectedItemColor: context.iconColor?.withValues(alpha: .6),
                  onTap: (idx) async {
                    if (curScroller.hasClients && idx == index) {
                      dctrl.jump;

                      switch (idx) {
                        case 0:
                          break;
                        default:
                          if (!pctrl.anyLoading) {
                            if (curIdx == 0) {
                              await pctrl.refreshPost;
                            } else {
                              await pctrl.refreshFollowing;
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
                duration: const Duration(milliseconds: 260),
                offset: visible ? Offset.zero : const Offset(0, 2),
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 260),
                  opacity: visible ? 1 : 0,
                  child: FloatingActionButton(
                    onPressed: () => context.pushNamed(route.create.name),
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
