import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:semesta/app/utils/custom_modal.dart';
import 'package:semesta/core/views/generic_helper.dart';
import 'package:semesta/core/mixins/repo_mixin.dart';
import 'package:semesta/core/views/feed_view.dart';
import 'package:semesta/core/views/utils_helper.dart';
import 'package:semesta/ui/components/layouts/_layout_page.dart';
import 'package:semesta/ui/components/layouts/custom_app_bar.dart';
import 'package:semesta/ui/components/globals/cached_tab.dart';
import 'package:semesta/ui/components/globals/live_feed.dart';
import 'package:semesta/ui/widgets/block_overlay.dart';

class BookmarkViewsPage extends StatelessWidget {
  final String uid;
  const BookmarkViewsPage({super.key, required this.uid});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Obx(() {
      final isLoading = pctrl.isLoading.value;

      return Stack(
        children: [
          LayoutPage(
            header: CustomAppBar(
              middle: Text('Bookmarks', style: TextStyle(fontSize: 24)),
              end: PopupMenuButton<String>(
                icon: Icon(Icons.more_vert, color: colors.secondary),
                tooltip: 'Clear all',
                onSelected: (value) {
                  if (value == 'clear') {
                    CustomModal(
                      context,
                      title: 'Clear all bookmarks?',
                      children: [
                        const Text('This will remove all saved posts.'),
                      ],
                      onConfirm: () async {
                        context.pop();
                        await pctrl.clearAllBookmarks();
                      },
                    );
                  }
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'clear',
                    child: Row(
                      spacing: 6,
                      children: [
                        Icon(Icons.delete_forever),
                        Text('Clear all Bookmarks'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            content: CachedTab<FeedView>(
              controller: pctrl,
              cache: pctrl.stateFor(getKey(uid: uid, screen: Screen.bookmark)),
              emptyMessage: "No bookmarks yet.",
              onInitial: () => pctrl.loadUserBookmarks(uid),
              onMore: () => pctrl.loadUserBookmarks(uid, QueryMode.next),
              onRefresh: () => pctrl.loadUserBookmarks(uid, QueryMode.refresh),
              itemBuilder: (item) => LiveFeed(feed: item),
            ),
          ),

          // ---- overlay ----
          isLoading ? BlockOverlay('Clearing') : SizedBox.shrink(),
        ],
      );
    });
  }
}
