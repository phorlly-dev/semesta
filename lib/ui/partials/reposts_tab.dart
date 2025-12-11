import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:semesta/app/routes/routes.dart';
import 'package:semesta/core/controllers/post_controller.dart';
import 'package:semesta/ui/components/global/private_post_card.dart';
import 'package:semesta/ui/widgets/display_repost.dart';
import 'package:semesta/ui/widgets/keep_alive_client.dart';
import 'package:semesta/ui/widgets/list_generated.dart';

class RepostsTab extends StatefulWidget {
  final String userId;
  const RepostsTab({super.key, required this.userId});

  @override
  State<RepostsTab> createState() => _RepostsTabState();
}

class _RepostsTabState extends State<RepostsTab> {
  final _routes = Routes();
  final _controller = Get.find<PostController>();

  @override
  void initState() {
    Future.microtask(() => loadInfo());
    super.initState();
  }

  Future<void> loadInfo() async {
    await _controller.loadReposts(widget.userId);
  }

  @override
  Widget build(BuildContext context) {
    final curId = _controller.currentId;
    final userCtrl = _controller.userCtrl;

    return KeepAliveClient(
      child: Obx(() {
        final posts = _controller.reposts;
        final isLoading = _controller.isLoading.value;

        return ListGenerated(
          onRefresh: loadInfo,
          counter: posts.length,
          builder: (idx) {
            final post = posts[idx];
            final viewerId = widget.userId;
            final model = _controller.dataMapping[post.id] ?? post;

            final isRepostedByUser = model.isReposted(viewerId);
            final isViewingSelf = viewerId == curId;
            final viewer =
                userCtrl.dataMapping[viewerId] ?? _controller.currentUser;
            final displayName = isViewingSelf ? 'You' : viewer.name;

            return PrivatePostCard(
              post: post,
              top: isRepostedByUser
                  ? DisplayRepost(
                      displayName: displayName,
                      isOwner: isViewingSelf,
                      onTap: () => context.pushNamed(
                        _routes.profile.name,
                        pathParameters: {'id': viewerId},
                        queryParameters: {'self': isViewingSelf.toString()},
                      ),
                    )
                  : SizedBox.shrink(),
            );
          },
          isEmpty: posts.isEmpty,
          isLoading: isLoading,
          neverScrollable: true,
          message: "There's no reposts yet.",
        );
      }),
    );
  }
}
