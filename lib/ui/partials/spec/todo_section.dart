import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:semesta/app/utils/format.dart';
import 'package:semesta/core/controllers/auth_controller.dart';
import 'package:semesta/core/controllers/user_controller.dart';
import 'package:semesta/ui/widgets/animated.dart';
import 'package:semesta/ui/widgets/avatar_animation.dart';

class TodoSection extends StatelessWidget {
  final String userId;
  const TodoSection({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<UserController>();

    return Container(
      padding: const EdgeInsets.all(8),
      color: Colors.white,
      child: Row(
        children: [
          Obx(() {
            final profile = controller.item.value;
            final imageUrl = profile?.avatar ?? setImage('default.png', true);

            return AvatarAnimation(
              imageUrl: imageUrl,
              onTap: () async {
                await Get.find<AuthController>().logout();
              },
            );
          }),

          SizedBox(width: 8),
          Expanded(
            child: Animated(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  border: Border.all(
                    color: Colors.black12,
                    style: BorderStyle.solid,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Text("What's on your mind?"),
                ),
              ),
              onTap: () {},
            ),
          ),
          SizedBox(width: 6),
          IconButton(
            splashRadius: 24,
            onPressed: () {},
            icon: const Icon(Icons.image, color: Colors.green, size: 32),
          ),
        ],
      ),
    );
  }
}
