import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:semesta/core/controllers/post_controller.dart';
import 'package:semesta/ui/widgets/keep_alive_client.dart';
import 'package:semesta/ui/widgets/list_grid_view.dart';
import 'package:semesta/ui/widgets/media_item.dart';

class MediaTab extends StatefulWidget {
  final String userId;
  const MediaTab({super.key, required this.userId});

  @override
  State<MediaTab> createState() => _MediaTabState();
}

class _MediaTabState extends State<MediaTab> {
  final _controller = Get.find<PostController>();

  @override
  void initState() {
    Future.microtask(() => loadInfo());
    super.initState();
  }

  Future<void> loadInfo() async {
    await _controller.loadMedia(widget.userId);
  }

  @override
  Widget build(BuildContext context) {
    return KeepAliveClient(
      child: Obx(() {
        final posts = _controller.media;
        final isLoading = _controller.isLoading.value;

        return ListGridView(
          counter: posts.length,
          onRefresh: loadInfo,
          isLoading: isLoading,
          message: "There's no media yet.",
          isEmpty: posts.isEmpty,
          builder: (idx) {
            final p = posts[idx];
            final m = p.media[0];
            return MediaItem(
              radius: 8,
              id: p.id,
              type: m.type,
              url: m.display,
              height: m.height.toDouble(),
              width: m.width.toDouble(),
            );
          },
        );
      }),
    );
  }
}
