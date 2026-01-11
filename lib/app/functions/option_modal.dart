import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:semesta/app/utils/custom_bottom_sheet.dart';
import 'package:semesta/app/utils/custom_modal.dart';
import 'package:semesta/app/functions/reply_option.dart';
import 'package:semesta/core/views/generic_helper.dart';
import 'package:semesta/core/models/feed.dart';
import 'package:semesta/core/views/audit_view.dart';
import 'package:semesta/core/views/class_helper.dart';
import 'package:semesta/ui/widgets/option_button.dart';

class OptionModal {
  final BuildContext context;
  OptionModal(this.context);

  ColorScheme get colors => Theme.of(context).colorScheme;

  void anotherOptions(
    Feed post,
    ActionTarget target, {
    bool iFollow = false,
    required String name,
    bool active = false,
    bool primary = true,
    required StatusView status,
  }) {
    CustomBottomSheet(
      context,
      children: [
        if (primary)
          OptionButton(
            icon: Icons.person,
            label: 'Go to Profile',
            onTap: () {
              context.pushNamed(
                route.profile.name,
                pathParameters: {'id': post.uid},
                queryParameters: {'self': 'false'},
              );
            },
          ),

        OptionButton(
          icon: active ? Icons.bookmark_remove_outlined : Icons.bookmark_border,
          label: active ? 'Unbookmark' : 'Bookmark',
          onTap: () async {
            await actrl.toggleBookmark(target, post.id, active: active);
          },
        ),

        OptionButton(
          icon: iFollow ? Icons.person_remove_alt_1 : Icons.person_add,
          label: iFollow ? 'Unfollow $name' : 'Follow $name',
          onTap: () async {
            if (iFollow) {
              CustomModal(
                context,
                title: 'Unfollow $name',
                children: [Text(unfollow)],
                onConfirm: () async {
                  context.pop();
                  status.toggle();
                  await actrl.toggleFollow(post.uid, iFollow);
                },
                label: 'Unfollow',
                icon: Icons.person_remove_sharp,
                color: colors.primary,
              );
            } else {
              status.toggle();
              await actrl.toggleFollow(post.uid, iFollow);
            }
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
    Feed post,
    ActionTarget target, {
    bool primary = true,
    bool active = false,
  }) {
    CustomBottomSheet(
      context,
      children: [
        if (primary)
          OptionButton(
            icon: Icons.person,
            label: 'Go to Profile',
            onTap: () {
              context.pushNamed(
                route.profile.name,
                pathParameters: {'id': post.uid},
                queryParameters: {'self': 'true'},
              );
            },
          ),

        OptionButton(
          icon: active ? Icons.bookmark_remove_outlined : Icons.bookmark_border,
          label: active ? 'Unbookmark' : 'Bookmark',
          onTap: () async {
            await actrl.toggleBookmark(target, post.id, active: active);
          },
        ),

        if (!primary)
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
              selected: show.mapVisibleToId(post.visible),
              onSelected: (id, opt) async {
                await pctrl.saveChange(post.id, {'visible': opt.name});
              },
            );
          },
        ),

        if (!primary)
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
                  await pctrl.remove(post.id, post.uid);
                },
                color: colors.error,
              );
            },
          ),
      ],
    );
  }

  void repostOptions(ActionsView vm) {
    CustomBottomSheet(
      context,
      children: [
        OptionButton(
          icon: Icons.autorenew_rounded,
          label: vm.reposted ? 'Undo Repost' : 'Repost',
          onTap: () {
            actrl.toggleRepost(vm.target, vm.pid, active: vm.reposted);
            vm.toggleRepost();
          },
        ),

        OptionButton(
          icon: Icons.edit_square,
          label: 'Quote',
          onTap: () async {
            await context.pushNamed(
              route.repost.name,
              pathParameters: {'id': vm.pid},
            );
          },
        ),
      ],
    );
  }

  void imageOptions(String path) {
    CustomBottomSheet(
      context,
      children: [
        OptionButton(
          icon: Icons.file_download_outlined,
          label: 'Save to photo',
          color: colors.secondary,
          onTap: () async {
            // await _files.saveImageToGallery(
            //   path,
            //   onProgress: (received, total) {
            //     if (total > 0) {
            //       final percent = (received / total * 100).toStringAsFixed(0);
            //       debugPrint('Downloading: $percent%');
            //     }

            //     CustomToast.info('Saved to gallery');
            //   },
            // );
          },
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
