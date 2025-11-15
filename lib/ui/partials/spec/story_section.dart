import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:semesta/app/utils/format.dart';
import 'package:semesta/core/controllers/story_controller.dart';
import 'package:semesta/core/controllers/user_controller.dart';
import 'package:semesta/ui/components/stories/create_story_card.dart';
import 'package:semesta/ui/components/stories/story_card.dart';

class StorySection extends StatelessWidget {
  final String userId;
  const StorySection({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    final userCtrl = Get.find<UserController>();
    final controller = Get.find<StoryController>();

    return Container(
      height: 180,
      margin: EdgeInsets.symmetric(vertical: 2),
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 6),
        children: [
          // 👇 Always fixed at the start
          Obx(() {
            final profile = userCtrl.item.value;
            return CreateStoryCard(
              avatar: profile?.avatar ?? setImage('default.png', true),
              onTap: () => controller.loadStoriesFromPexels(),
            );
          }),

          // 👇 Followed by all story items (loop)
          Obx(() {
            final stories = controller.items;
            final users = controller.userMap;

            return Row(
              children: List.generate(stories.length, (idx) {
                final story = stories[idx];
                final isOwner = userId == story.userId;

                return StoryCard(
                  story: story,
                  user: users[story.userId],
                  isOwner: isOwner,
                );
              }),
            );
          }),
        ],
      ),
    );
  }
}
