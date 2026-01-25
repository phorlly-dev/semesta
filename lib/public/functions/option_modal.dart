import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:semesta/public/extensions/extension.dart';
import 'package:semesta/public/utils/custom_bottom_sheet.dart';
import 'package:semesta/public/utils/custom_modal.dart';
import 'package:semesta/public/functions/visible_option.dart';
import 'package:semesta/public/helpers/generic_helper.dart';
import 'package:semesta/app/models/feed.dart';
import 'package:semesta/public/helpers/audit_view.dart';
import 'package:semesta/public/helpers/class_helper.dart';
import 'package:semesta/src/widgets/main/option_button.dart';

class OptionModal {
  final BuildContext _context;
  const OptionModal(this._context);

  ColorScheme get colors => Theme.of(_context).colorScheme;

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
      _context,
      children: [
        if (primary)
          OptionButton(
            'Go to Profile',
            icon: Icons.person,
            onTap: () async {
              await _context.openProfile(post.uid, false);
            },
          ),

        OptionButton(
          active ? 'Unbookmark' : 'Bookmark',
          icon: active ? Icons.bookmark_remove_outlined : Icons.bookmark_border,
          onTap: () async {
            await actrl.toggleBookmark(target, post.id, active: active);
          },
        ),

        OptionButton(
          iFollow ? 'Unfollow $name' : 'Follow $name',
          icon: iFollow ? Icons.person_remove_alt_1 : Icons.person_add,
          onTap: () async {
            if (iFollow) {
              CustomModal(
                _context,
                title: 'Unfollow $name',
                children: [Text(unfollow)],
                onConfirm: () async {
                  _context.pop();
                  status.toggle();
                  await actrl.toggleFollow(post.uid, iFollow);
                },
                icon: Icons.person_remove_sharp,
                color: colors.primary,
                label: 'Unfollow',
              );
            } else {
              status.toggle();
              await actrl.toggleFollow(post.uid, iFollow);
            }
          },
        ),

        OptionButton(
          'Not interested',
          icon: Icons.visibility_off_outlined,
          onTap: () {},
        ),

        OptionButton(
          'Block',
          icon: Icons.person_off,
          color: colors.error,
          onTap: () {},
        ),

        OptionButton(
          'Report',
          icon: Icons.report_problem_outlined,
          color: colors.error,
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
      _context,
      children: [
        if (primary)
          OptionButton(
            icon: Icons.person,
            'Go to Profile',
            onTap: () async {
              await _context.openProfile(post.uid, true);
            },
          ),

        OptionButton(
          active ? 'Unbookmark' : 'Bookmark',
          icon: active ? Icons.bookmark_remove_outlined : Icons.bookmark_border,
          onTap: () async {
            await actrl.toggleBookmark(target, post.id, active: active);
          },
        ),

        if (!primary)
          OptionButton(
            'Edit Post',
            icon: Icons.edit_square,
            onTap: () {},
            color: colors.scrim,
          ),

        OptionButton(
          'Change who can reply',
          icon: 'comment.png',
          color: colors.primary,
          onTap: () {
            final show = VisibleOption(_context);
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
            'Delete post',
            icon: Icons.delete_outline,
            color: colors.error,
            onTap: () {
              CustomModal(
                _context,
                title: 'Delete Post?',
                children: [
                  const Text(
                    "If you delete this post, you won't be able to restore it.",
                  ),
                ],
                onConfirm: () async {
                  _context.pop();
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
      _context,
      children: [
        OptionButton(
          icon: Icons.autorenew_rounded,
          vm.reposted ? 'Undo Repost' : 'Repost',
          onTap: () {
            actrl.toggleRepost(vm.target, vm.pid, active: vm.reposted);
            vm.toggleRepost();
          },
        ),

        OptionButton(
          'Quote',
          icon: Icons.edit_square,
          onTap: () async {
            await _context.openById(route.repost, vm.pid);
          },
        ),
      ],
    );
  }

  void imageOptions(String path) {
    CustomBottomSheet(
      _context,
      children: [
        OptionButton(
          icon: Icons.file_download_outlined,
          'Save to photo',
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
          'Share external',
          color: colors.secondary,
          onTap: () {},
        ),
        OptionButton(
          icon: Icons.report_outlined,
          'Report photo',
          color: colors.secondary,
          onTap: () {},
        ),
      ],
    );
  }
}
