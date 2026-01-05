import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:semesta/app/functions/option_modal.dart';
import 'package:semesta/app/routes/routes.dart';
import 'package:semesta/core/controllers/action_controller.dart';
import 'package:semesta/core/views/audit_view.dart';
import 'package:semesta/ui/widgets/action_button.dart';

class CachedActions extends StatelessWidget {
  final ActionsView vm;
  const CachedActions({super.key, required this.vm});

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).hintColor;
    final routes = Routes();
    final options = OptionModal(context);
    final ctrl = Get.find<ActionController>();

    return Row(
      children: [
        // --- Left group: engagement actions ---
        Row(
          spacing: 12,
          children: [
            // Comment
            ActionButton(
              icon: 'comment.png',
              label: vm.comments,
              iconColor: color,
              onPressed: () async {
                await context.pushNamed(
                  routes.replyPost.name,
                  pathParameters: {'id': vm.pid},
                );
              },
            ),

            // Like
            ActionButton(
              icon: vm.favorited ? Icons.favorite : Icons.favorite_border,
              label: vm.favorites,
              isActive: vm.favorited,
              iconColor: vm.favorited ? Colors.redAccent : color,
              onPressed: () async {
                await ctrl.toggleFavorite(
                  vm.target,
                  vm.pid,
                  active: vm.favorited,
                );
              },
            ),

            // Repost
            ActionButton(
              icon: Icons.autorenew_rounded,
              label: vm.reposts,
              iconColor: vm.reposted ? Colors.green : color,
              isActive: vm.reposted,
              onPressed: () => options.repostOptions(vm),
            ),

            // Views
            ActionButton(
              icon: Icons.remove_red_eye_outlined,
              label: vm.views,
              iconColor: color,
            ),
          ],
        ),

        Spacer(),

        // --- Right group: secondary actions ---
        Row(
          spacing: 4,
          children: [
            ActionButton(
              icon: vm.bookmarked
                  ? Icons.bookmark
                  : Icons.bookmark_border_rounded,
              iconColor: vm.bookmarked ? Colors.blueAccent : color,
              // label: saves,
              isActive: vm.bookmarked,
              onPressed: () async {
                await ctrl.toggleBookmark(
                  vm.target,
                  vm.pid,
                  active: vm.bookmarked,
                );
              },
            ),

            // Share
            ActionButton(
              icon: Icons.ios_share_rounded,
              iconColor: color,
              // label: shares,
            ),
          ],
        ),
        // Save
      ],
    );
  }
}
