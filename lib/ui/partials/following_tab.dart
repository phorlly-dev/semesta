import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:semesta/core/controllers/user_controller.dart';
import 'package:semesta/ui/components/users/follow_tile.dart';
import 'package:semesta/ui/widgets/keep_alive_client.dart';
import 'package:semesta/ui/widgets/list_generated.dart';

class FollowingTab extends StatefulWidget {
  final String userId;
  const FollowingTab({super.key, required this.userId});

  @override
  State<FollowingTab> createState() => _FollowingTabState();
}

class _FollowingTabState extends State<FollowingTab> {
  final _controller = Get.find<UserController>();

  @override
  void initState() {
    Future.microtask(loadInfo);
    super.initState();
  }

  Future<void> loadInfo() async {
    await _controller.loadFollowings(widget.userId);
  }

  @override
  Widget build(BuildContext context) {
    return KeepAliveClient(
      child: Obx(() {
        final users = _controller.followings;
        final isLoading = _controller.isLoading.value;

        return ListGenerated(
          onRefresh: loadInfo,
          counter: users.length,
          builder: (idx) => FollowTile(user: users[idx]),
          isEmpty: users.isEmpty,
          isLoading: isLoading,
          neverScrollable: true,
          message: "There's no followings yet.",
        );
      }),
    );
  }
}
