import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:semesta/app/functions/custom_bottom_sheet.dart';
import 'package:semesta/app/functions/custom_modal.dart';
import 'package:semesta/app/functions/reply_option.dart';
import 'package:semesta/app/routes/routes.dart';
import 'package:semesta/core/controllers/action_controller.dart';
import 'package:semesta/core/controllers/post_controller.dart';
import 'package:semesta/core/models/post_model.dart';
import 'package:semesta/ui/widgets/option_button.dart';

class OptionModal {
  final BuildContext context;
  ColorScheme get colors => Theme.of(context).colorScheme;

  final _routes = Routes();
  final _postCtrl = Get.find<PostController>();
  final _actionCtrl = Get.find<ActionController>();

  OptionModal(this.context);

  void unfollow(String userId, String username) {
    CustomBottomSheet(
      context,
      children: [
        OptionButton(
          icon: Icons.person_remove_alt_1,
          label: 'Unfollow',
          color: colors.secondary,
          onTap: () {
            CustomModal(
              context,
              title: '@$username',
              onConfirm: () async {
                context.pop();
                await _postCtrl.toggleFollow(userId, true);
              },
              label: 'Unfollow',
              icon: Icons.person_remove_sharp,
              color: colors.primary,
            );
          },
        ),
      ],
    );
  }

  void postOptions(
    String postId,
    String userId, {
    PostVisibility option = PostVisibility.everyone,
    bool isPrivate = false,
  }) {
    if (isPrivate) {
      CustomBottomSheet(
        context,
        children: [
          OptionButton(
            icon: Icons.edit_square,
            label: 'Edit Post',
            onTap: () {},
            color: colors.scrim,
          ),

          OptionButton(
            icon: 'comment.png',
            label: 'Change who can reply',
            color: colors.primary,
            onTap: () {
              final show = ReplyOption(context);
              show.showModal(
                selected: show.mapVisibleToId(option),
                onSelected: (id, opt) async {
                  await _postCtrl.saveChange(postId, {'visibility': opt.name});
                  unawaited(_actionCtrl.loadPosts(userId));
                  unawaited(_postCtrl.many(force: true));
                },
              );
            },
          ),

          OptionButton(
            icon: Icons.delete_outline,
            label: 'Delete post',
            color: colors.error,
            onTap: () {
              CustomModal(
                context,
                title: 'Delete Post?',
                children: [
                  const Text(
                    "If you delete this post, you won't be able to restore it.",
                  ),
                ],
                onConfirm: () async {
                  context.pop();
                  await _postCtrl.remove(postId, userId);
                  unawaited(_actionCtrl.loadPosts(userId));
                  unawaited(_postCtrl.many(force: true));
                },
                color: colors.error,
              );
            },
          ),
        ],
      );
    }
  }

  void repostOptions(String postId, bool isReposted) {
    CustomBottomSheet(
      context,
      children: [
        OptionButton(
          icon: Icons.autorenew_rounded,
          label: isReposted ? 'Undo Repost' : 'Repost',
          onTap: () async {
            await _actionCtrl.toggleRepost(postId, isReposted);
          },
          color: colors.scrim,
        ),

        OptionButton(
          icon: Icons.edit_square,
          label: 'Quote',
          color: colors.primary,
          onTap: () async {
            await context.pushNamed(
              _routes.repost.name,
              pathParameters: {'id': postId},
            );
          },
        ),
      ],
    );
  }
}
