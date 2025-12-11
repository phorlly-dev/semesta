import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:semesta/app/functions/custom_modal.dart';
import 'package:semesta/core/controllers/post_controller.dart';
import 'package:semesta/ui/components/global/public_post_card.dart';
import 'package:semesta/ui/components/global/_layout_page.dart';
import 'package:semesta/ui/components/global/nav_bar_layer.dart';
import 'package:semesta/ui/widgets/list_generated.dart';

class SavedViewsPage extends StatefulWidget {
  final String userId;
  const SavedViewsPage({super.key, required this.userId});

  @override
  State<SavedViewsPage> createState() => _SavedViewsPageState();
}

class _SavedViewsPageState extends State<SavedViewsPage> {
  final _controller = Get.find<PostController>();

  @override
  void initState() {
    Future.microtask(() => _controller.loadSaves(widget.userId));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
                  await _controller.clearAllSaves();
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
        final saves = _controller.saves;
        final isLoading = _controller.isLoading.value;

        return ListGenerated(
          onRefresh: () async => await _controller.loadSaves(widget.userId),
          counter: saves.length,
          isEmpty: saves.isEmpty,
          isLoading: isLoading,
          message: "No bookmarks yet.",
          builder: (idx) => PublicPostCard(post: saves[idx]),
        );
      }),
    );
  }
}
