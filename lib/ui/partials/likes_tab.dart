import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:semesta/core/controllers/post_controller.dart';
import 'package:semesta/ui/components/global/private_post_card.dart';
import 'package:semesta/ui/widgets/keep_alive_client.dart';
import 'package:semesta/ui/widgets/list_generated.dart';

class LikesTab extends StatefulWidget {
  final String userId;
  const LikesTab({super.key, required this.userId});

  @override
  State<LikesTab> createState() => _LikesTabState();
}

class _LikesTabState extends State<LikesTab> {
  final _controller = Get.find<PostController>();

  @override
  void initState() {
    Future.microtask(() => loadInfo());
    super.initState();
  }

  Future<void> loadInfo() async {
    await _controller.loadLikes(widget.userId);
  }

  @override
  Widget build(BuildContext context) {
    return KeepAliveClient(
      child: Obx(() {
        final posts = _controller.likes;
        final isLoading = _controller.isLoading.value;

        return ListGenerated(
          onRefresh: loadInfo,
          counter: posts.length,
          builder: (idx) => PrivatePostCard(post: posts[idx]),
          isEmpty: posts.isEmpty,
          isLoading: isLoading,
          neverScrollable: true,
          message: "There's no likes yet.",
        );
      }),
    );
  }
}
