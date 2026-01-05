import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:semesta/app/functions/custom_modal.dart';
import 'package:semesta/core/mixins/repo_mixin.dart';
import 'package:semesta/core/controllers/post_controller.dart';
import 'package:semesta/core/views/feed_view.dart';
import 'package:semesta/ui/components/layouts/_layout_page.dart';
import 'package:semesta/ui/components/layouts/nav_bar_layer.dart';
import 'package:semesta/ui/components/globals/cached_tab.dart';
import 'package:semesta/ui/components/globals/live_feed.dart';

class BookmarkViewsPage extends StatelessWidget {
  final String uid;
  const BookmarkViewsPage({super.key, required this.uid});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PostController>();
    return LayoutPage(
      header: NavBarLayer(
        middle: Text('Bookmarks', style: TextStyle(fontSize: 24)),
        end: PopupMenuButton<String>(
          icon: const Icon(Icons.more_vert),
          onSelected: (value) {
            if (value == 'clear') {
              CustomModal(
                context,
                title: 'Clear all bookmarks?',
                children: [const Text('This will remove all saved posts.')],
                onConfirm: () async {
                  context.pop();
                  await controller.clearAllBookmarks();
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
        controller: controller,
        cache: controller.stateFor('user:$uid:bookmarks'),
        emptyMessage: "No bookmarks yet.",
        onInitial: () => controller.loadUserBookmarks(uid),
        onMore: () => controller.loadUserBookmarks(uid, QueryMode.next),
        onRefresh: () => controller.loadUserBookmarks(uid, QueryMode.refresh),
        itemBuilder: (item) => LiveFeed(feed: item),
      ),
    );
  }
}
