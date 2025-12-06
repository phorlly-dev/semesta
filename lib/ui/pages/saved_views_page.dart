import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:semesta/app/functions/custom_modal.dart';
import 'package:semesta/core/controllers/action_controller.dart';
import 'package:semesta/ui/components/posts/post_card.dart';
import 'package:semesta/ui/components/global/_layout_page.dart';
import 'package:semesta/ui/components/global/nav_bar_layer.dart';
import 'package:semesta/ui/widgets/list_generated.dart';

class SavedViewsPage extends StatelessWidget {
  final String userId;
  const SavedViewsPage({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ActionController>();

    Future.microtask(() => controller.loadSaves(userId));

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
                  await controller.clearAllSaves();
                },
              );
            }
          },
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'clear',
              child: Text('Clear all Bookmarks'),
            ),
          ],
        ),
      ),
      content: Obx(() {
        final saves = controller.saves;

        return ListGenerated(
          onRefresh: () async => await controller.loadSaves(userId),
          counter: saves.length,
          textEmpty: 'No bookmarks yet.',
          builder: (idx) => PostCard(post: saves[idx]),
          isEmpty: saves.isEmpty,
          isLoading: controller.isLoading.value,
        );
      }),
    );
  }
}
