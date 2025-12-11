import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:semesta/app/functions/custom_bottom_sheet.dart';
import 'package:semesta/app/functions/custom_modal.dart';
import 'package:semesta/app/functions/reply_option.dart';
import 'package:semesta/app/routes/routes.dart';
import 'package:semesta/core/controllers/post_controller.dart';
import 'package:semesta/core/models/post_model.dart';
import 'package:semesta/core/models/user_model.dart';
import 'package:semesta/ui/widgets/option_button.dart';

class OptionModal {
  final BuildContext context;
  ColorScheme get colors => Theme.of(context).colorScheme;

  final _routes = Routes();
  final _controller = Get.find<PostController>();

  OptionModal(this.context);

  void anotherOptions(
    UserModel user,
    String postId, {
    bool isFollowing = false,
    bool isSaved = false,
  }) {
    CustomBottomSheet(
      context,
      children: [
        OptionButton(
          icon: isSaved
              ? Icons.bookmark_remove_outlined
              : Icons.bookmark_border,
          label: isSaved ? 'Unbookmark' : 'Bookmark',
          onTap: () async {
            await _controller.toggleSave(postId, isSaved);
          },
        ),
        if (isFollowing)
          OptionButton(
            icon: Icons.person_remove_alt_1,
            label: 'Unfollow',
            onTap: () {
              CustomModal(
                context,
                title: '@${user.username}',
                onConfirm: () async {
                  context.pop();
                  await _controller.toggleFollow(user.id, true);
                },
                label: 'Unfollow',
                icon: Icons.person_remove_sharp,
                color: colors.primary,
              );
            },
          ),
        OptionButton(
          icon: Icons.visibility_off_outlined,
          label: 'Not interested',
          onTap: () {},
        ),
        OptionButton(
          icon: Icons.person_off,
          color: colors.error,
          label: 'Block',
          onTap: () {},
        ),
        OptionButton(
          icon: Icons.report_problem_outlined,
          color: colors.error,
          label: 'Report',
          onTap: () {},
        ),
      ],
    );
  }

  void currentOptions(
    String postId,
    String userId, {
    PostVisibility option = PostVisibility.everyone,
    bool isPrivate = false,
    bool isSaved = false,
  }) {
    CustomBottomSheet(
      context,
      children: [
        if (!isPrivate)
          OptionButton(
            icon: Icons.person,
            label: 'Go to Profile',
            onTap: () {
              context.pushNamed(
                _routes.profile.name,
                pathParameters: {'id': userId},
                queryParameters: {'self': 'true'},
              );
            },
          ),

        OptionButton(
          icon: isSaved
              ? Icons.bookmark_remove_outlined
              : Icons.bookmark_border,
          label: isSaved ? 'Unbookmark' : 'Bookmark',
          onTap: () async {
            await _controller.toggleSave(postId, isSaved);
          },
        ),

        if (isPrivate)
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
                await _controller.saveChange(postId, {'visibility': opt.name});
                unawaited(_controller.loadPosts(userId));
                unawaited(_controller.loadMoreForYou());
              },
            );
          },
        ),

        if (isPrivate)
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
                  await _controller.remove(postId, userId);
                  unawaited(_controller.loadPosts(userId));
                  unawaited(_controller.loadMoreForYou());
                },
                color: colors.error,
              );
            },
          ),
      ],
    );
  }

  void repostOptions(String postId, bool isReposted) {
    CustomBottomSheet(
      context,
      children: [
        OptionButton(
          icon: Icons.autorenew_rounded,
          label: isReposted ? 'Undo Repost' : 'Repost',
          onTap: () async {
            await _controller.toggleRepost(postId, isReposted);
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

  void imageOptions() {
    CustomBottomSheet(
      context,
      children: [
        OptionButton(
          icon: Icons.file_download_outlined,
          label: 'Save to photo',
          color: colors.secondary,
          onTap: () {},
        ),
        OptionButton(
          icon: 'share.png',
          label: 'Share external',
          color: colors.secondary,
          onTap: () {},
        ),
        OptionButton(
          icon: Icons.report_outlined,
          label: 'Report photo',
          color: colors.secondary,
          onTap: () {},
        ),
      ],
    );
  }
}
