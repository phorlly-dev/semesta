import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:semesta/public/extensions/context_extension.dart';
import 'package:semesta/public/extensions/model_extension.dart';
import 'package:semesta/public/extensions/string_extension.dart';
import 'package:semesta/public/functions/custom_toast.dart';
import 'package:semesta/public/utils/custom_modal.dart';
import 'package:semesta/public/helpers/generic_helper.dart';
import 'package:semesta/public/helpers/audit_view.dart';
import 'package:semesta/src/widgets/main/option_button.dart';
import 'package:sn_progress_dialog/sn_progress_dialog.dart';

class OptionModal {
  final BuildContext _context;
  const OptionModal(this._context);

  void tagetOptions(
    StatusView status,
    ActionsView actions, {
    bool profiled = true,
  }) {
    final author = status.author;
    final active = actions.bookmarked;
    final uid = author.id;
    final name = author.name;
    final iFollow = status.iFollow;

    _context.sheet(
      children: [
        if (!profiled)
          OptionButton(
            'Go to profile',
            icon: Icons.person,
            onTap: () async {
              await _context.openProfile(uid, false);
            },
          ),

        OptionButton(
          active ? 'Unsave' : 'Save',
          icon: active ? Icons.bookmark_remove_outlined : Icons.bookmark_border,
          onTap: () {
            actions.toggleBookmark();
            actrl.toggleBookmark(actions);
          },
        ),

        OptionButton(
          iFollow ? 'Unfollow $name' : 'Follow $name',
          icon: iFollow ? Icons.person_remove_alt_1 : Icons.person_add,
          onTap: () {
            if (iFollow) {
              CustomModal<String>(
                _context,
                title: 'Unfollow $name',
                children: [Text(unfollow)],
                onConfirm: () {
                  status.toggle();
                  _context.pop();
                  actrl.toggleFollow(status);
                },
                icon: Icons.person_remove_sharp,
                color: _context.primaryColor,
                label: 'Unfollow',
              );
            } else {
              status.toggle();
              actrl.toggleFollow(status);
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

  void currentOptions(ActionsView actions, {bool profiled = false}) {
    final post = actions.feed;
    final active = actions.bookmarked;

    _context.sheet(
      children: [
        if (profiled && post.editable)
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
                  'Edit post',
                  icon: Icons.edit_square,
                  status: Text(
                    post.formatMMSS(remaining),
                    style: _context.text.bodyMedium?.copyWith(
                      color: _context.outlineColor,
                    ),
                  ),
                  onTap: () async {
                    await _context.openById(routes.change, post.id);
                  },
                ),
              );
            },
          ),

        if (!profiled)
          OptionButton(
            icon: Icons.person,
            'Go to profile',
            onTap: () async {
              await _context.openProfile(post.uid, true);
            },
          ),

        OptionButton(
          active ? 'Unsave' : 'Save',
          icon: active ? Icons.bookmark_remove_outlined : Icons.bookmark_border,
          onTap: () {
            actions.toggleBookmark();
            actrl.toggleBookmark(actions);
          },
        ),

        if (profiled)
          OptionButton(
            'Change who can reply',
            icon: 'comment.png',
            color: _context.primaryColor,
            onTap: () {
              _context.show(
                post.visible,
                onChanged: (opt) async {
                  await pctrl.saveChange(post.copy(visible: opt, edited: true));
                },
              );
            },
          ),

        if (profiled)
          OptionButton(
            'Delete post',
            icon: Icons.delete_outline,
            color: _context.errorColor,
            onTap: () {
              CustomModal<String>(
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

        SizedBox(height: profiled ? 12 : 6),
      ],
    );
  }

  void repostOptions(ActionsView actions) => _context.sheet(
    children: [
      OptionButton(
        actions.reposted ? 'Undo Repost' : 'Repost',
        icon: Icons.autorenew_rounded,
        onTap: () {
          actions.toggleRepost();
          actrl.toggleRepost(actions);
        },
      ),

      OptionButton(
        'Quote',
        icon: Icons.edit_square,
        onTap: () async {
          await _context.openById(routes.repost, actions.pid);
        },
      ),
      const SizedBox(height: 12),
    ],
  );

  void shareOptions(ActionsView actions) => _context.sheet(
    children: [
      Padding(
        padding: const EdgeInsets.only(left: 8, bottom: 16),
        child: Text(
          'Share post',
          style: _context.text.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      OptionButton(
        icon: Icons.email_outlined,
        'Send via Direct Message',
        onTap: () async {},
      ),

      OptionButton(icon: 'share.png', 'Share post via...', onTap: () {}),

      OptionButton(
        actions.bookmarked ? 'Unsave' : 'Save',
        icon: actions.bookmarked
            ? Icons.bookmark_remove_outlined
            : Icons.bookmark_border,
        onTap: () {
          actions.toggleBookmark();
          actrl.toggleBookmark(actions);
        },
      ),

      OptionButton(icon: Icons.copy_outlined, 'Copy link', onTap: () {}),

      const SizedBox(height: 12),
    ],
  );

  void imageOptions(String path, ProgressDialog pd) => _context.sheet(
    children: [
      OptionButton(
        'Save to photo',
        icon: Icons.file_download_outlined,
        onTap: () async {
          pd.show(
            max: 100,
            msg: 'File Downloading...',
            completed: Completed(
              completedMsg: 'Downloading Done !',
              completionDelay: 2500,
            ),
          );
          await path.toDownload((received, total) {
            if (total <= 0) return;

            final progress = ((received / total) * 100).clamp(0, 100).toInt();
            pd.update(value: progress, msg: 'Downloading... $progress%');

            if (progress >= 100) {
              pd.close();
              CustomToast.info('Saved to gallery');
            }
          });
        },
      ),

      OptionButton(icon: 'share.png', 'Share external', onTap: () {}),

      OptionButton(icon: Icons.report_outlined, 'Report photo', onTap: () {}),

      const SizedBox(height: 12),
    ],
  );
}
