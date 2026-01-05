import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:semesta/app/extensions/controller_extension.dart';
import 'package:semesta/core/controllers/action_controller.dart';
import 'package:semesta/core/views/feed_view.dart';
import 'package:semesta/ui/components/layouts/card_skeleton.dart';
import 'package:semesta/ui/components/globals/post_card.dart';

class LiveFeed extends StatelessWidget {
  final FeedView feed;
  final bool me;
  const LiveFeed({super.key, required this.feed, this.me = false});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<ActionController>();
    return StreamBuilder<FeedStateView>(
      stream: ctrl.feedStream$(feed),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const CardSkeleton(); // 👈 smooth loading
        }

        final vm = snapshot.data!;
        return PostCard(vm: vm, me: me);
      },
    );
  }
}
