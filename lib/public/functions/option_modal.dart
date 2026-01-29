import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:semesta/public/extensions/extension.dart';
import 'package:semesta/public/extensions/model_extension.dart';
import 'package:semesta/public/utils/custom_bottom_sheet.dart';
import 'package:semesta/public/utils/custom_modal.dart';
import 'package:semesta/public/helpers/generic_helper.dart';
import 'package:semesta/app/models/feed.dart';
import 'package:semesta/public/helpers/audit_view.dart';
import 'package:semesta/public/helpers/class_helper.dart';
import 'package:semesta/src/widgets/main/option_button.dart';

class OptionModal {
  final BuildContext _context;
  const OptionModal(this._context);

  void anotherOptions(
    Feed post,
    ActionTarget target, {
    bool iFollow = false,
    bool active = false,
    bool profiled = true,
    required String name,
    required StatusView status,
  }) {
    CustomBottomSheet(
      _context,
      children: [
        if (profiled)
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
                  status.toggle();
                  _context.pop();
                  await actrl.toggleFollow(post.uid, iFollow);
                },
                icon: Icons.person_remove_sharp,
                color: _context.primaryColor,
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
          color: _context.errorColor,
          onTap: () {},
        ),

        OptionButton(
          'Report',
          icon: Icons.report_problem_outlined,
          color: _context.errorColor,
          onTap: () {},
        ),
      ],
    );
  }

  void currentOptions(
    Feed post,
    ActionTarget target, {
    bool profiled = false,
    bool active = false,
  }) {
    CustomBottomSheet(
      _context,
      children: [
        if (profiled && post.isEditable)
          StreamBuilder(
            stream: post.editCountdown$,
            builder: (_, snap) {
              if (!snap.hasData || snap.data == Duration.zero) {
                return const SizedBox.shrink();
              }

              final remaining = snap.data!;
              final opacity = remaining.inSeconds <= 10 ? 0.6 : 1.0;

              return Opacity(
                opacity: opacity,
                child: OptionButton(
                  'Edit Post',
                  icon: Icons.edit_square,
                  status: Text(
                    post.formatMMSS(remaining),
                    style: _context.text.bodyMedium?.copyWith(
                      color: _context.outlineColor,
                    ),
                  ),
                  onTap: () async {
                    await _context.openById(route.change, post.id);
                  },
                ),
              );
            },
          ),

        if (!profiled)
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

        OptionButton(
          'Change who can reply',
          icon: 'comment.png',
          color: _context.primaryColor,
          onTap: () {
            _context.tap.showModal(
              selected: _context.tap.mapVisibleToId(post.visible),
              onSelected: (_, opt) async {
                await pctrl.saveChange(
                  post,
                  post.copy(visible: opt, edited: true).to(),
                );
              },
            );
          },
        ),

        if (profiled) ...[
          OptionButton(
            'Delete post',
            icon: Icons.delete_outline,
            color: _context.errorColor,
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
                  await pctrl.remove(post);
                },
                color: _context.errorColor,
              );
            },
          ),
          const SizedBox(height: 12),
        ],
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
        const SizedBox(height: 12),
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
          color: _context.secondaryColor,
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
          color: _context.secondaryColor,
          onTap: () {},
        ),

        OptionButton(
          icon: Icons.report_outlined,
          'Report photo',
          color: _context.secondaryColor,
          onTap: () {},
        ),

        const SizedBox(height: 12),
      ],
    );
  }
}
