import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:semesta/app/utils/scroll_helper.dart';
import 'package:semesta/core/controllers/action_controller.dart';
import 'package:semesta/core/controllers/user_controller.dart';
import 'package:semesta/ui/components/users/account_profile.dart';
import 'package:semesta/ui/partials/likes_tab.dart';
import 'package:semesta/ui/partials/posts_tab.dart';
import 'package:semesta/ui/components/global/_layout_page.dart';
import 'package:semesta/ui/partials/replies_tab.dart';
import 'package:semesta/ui/partials/reposts_tab.dart';
import 'package:semesta/ui/widgets/list_generated.dart';

class ProfileViewPage extends StatelessWidget {
  final String userId, postId;

  const ProfileViewPage({
    super.key,
    required this.userId,
    required this.postId,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ActionController>();
    final scroller = Get.find<ScrollHelper>();
    final userCtrl = Get.find<UserController>();

    Future.microtask(() => controller.loadProfileData(userId));

    return Obx(() {
      final isOwner = userCtrl.isCurrentUser(userId);
      final posts = controller.elements;
      final replies = controller.replies;
      // final media = controller.media;
      final reposts = controller.reposts;
      final likes = controller.likes;

      return LayoutPage(
        content: AccountProfile(
          userId: userId,
          scroller: scroller.scrollControllers[3],
          children: [
            ListGenerated(
              onRefresh: () async => await controller.loadPosts(userId),
              counter: posts.length,
              builder: (idx) => PostsTab(post: posts[idx]),
              isEmpty: posts.isEmpty,
              isLoading: controller.isLoading.value,
              textEmpty: "There's no post yet.",
            ),

            ListGenerated(
              onRefresh: () async => await controller.loadReplies(postId),
              counter: replies.length,
              builder: (idx) => RepliesTab(post: replies[idx]),
              isEmpty: replies.isEmpty,
              isLoading: controller.isLoading.value,
              textEmpty: "There's no reply yet.",
            ),

            ListGenerated(
              onRefresh: () async => await controller.loadLikes(userId),
              counter: likes.length,
              builder: (idx) => LikesTab(post: likes[idx]),
              isEmpty: likes.isEmpty,
              isLoading: controller.isLoading.value,
              textEmpty: "There's no media yet.",
            ),

            ListGenerated(
              onRefresh: () async => await controller.loadReposts(userId),
              counter: reposts.length,
              builder: (idx) => RepostsTab(post: reposts[idx]),
              isEmpty: reposts.isEmpty,
              isLoading: controller.isLoading.value,
              textEmpty: "There's no repost yet.",
            ),

            if (isOwner)
              ListGenerated(
                onRefresh: () async => await controller.loadLikes(userId),
                counter: likes.length,
                builder: (idx) => LikesTab(post: likes[idx]),
                isEmpty: likes.isEmpty,
                isLoading: controller.isLoading.value,
                textEmpty: "There's no like yet.",
              ),
          ],
        ),
      );
    });
  }
}
