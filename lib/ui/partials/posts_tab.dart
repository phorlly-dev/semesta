import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:semesta/core/controllers/post_controller.dart';
import 'package:semesta/ui/components/global/private_post_card.dart';
import 'package:semesta/ui/widgets/keep_alive_client.dart';
import 'package:semesta/ui/widgets/list_generated.dart';

class PostsTab extends StatefulWidget {
  final String userId;
  const PostsTab({super.key, required this.userId});

  @override
  State<PostsTab> createState() => _PostsTabState();
}

class _PostsTabState extends State<PostsTab> {
  final _controller = Get.find<PostController>();

  @override
  void initState() {
    Future.microtask(() => loadInfo());
    super.initState();
  }

  Future<void> loadInfo() async {
    await _controller.loadPosts(widget.userId);
  }

  @override
  Widget build(BuildContext context) {
    return KeepAliveClient(
      child: Obx(() {
        final posts = _controller.elements;
        final isLoading = _controller.isLoading.value;

        return ListGenerated(
          onRefresh: loadInfo,
          counter: posts.length,
          builder: (idx) => PrivatePostCard(post: posts[idx]),
          isEmpty: posts.isEmpty,
          isLoading: isLoading,
          neverScrollable: true,
          message: "There's no posts yet.",
        );
      }),
    );
  }
}
