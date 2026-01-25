import 'package:flutter/material.dart';
import 'package:semesta/public/extensions/extension.dart';
import 'package:semesta/public/functions/option_modal.dart';
import 'package:semesta/public/helpers/generic_helper.dart';
import 'package:semesta/public/helpers/audit_view.dart';
import 'package:semesta/src/widgets/main/action_button.dart';

class ActionsBar extends StatelessWidget {
  final ActionsView _actions;
  const ActionsBar(this._actions, {super.key});

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).hintColor;
    final options = OptionModal(context);

    return Padding(
      padding: const EdgeInsetsDirectional.only(
        start: 60,
        end: 12,
        bottom: 8,
        top: 12,
      ),
      child: AnimatedBuilder(
        animation: _actions,
        builder: (_, child) => Row(
          children: [
            // --- Left group: engagement actions ---
            Row(
              spacing: 24,
              children: [
                // Comment
                ActionButton(
                  icon: 'comment.png',
                  label: _actions.comments,
                  iconColor: color,
                  onPressed: () async {
                    await context.openById(route.comment, _actions.pid);
                  },
                ),

                // Like
                ActionButton(
                  icon: _actions.favorited
                      ? Icons.favorite
                      : Icons.favorite_border,
                  label: _actions.favorites,
                  isActive: _actions.favorited,
                  iconColor: _actions.favorited ? Colors.redAccent : color,
                  onPressed: () async {
                    await actrl.toggleFavorite(
                      _actions.target,
                      _actions.pid,
                      active: _actions.favorited,
                    );
                    _actions.toggleFavorite();
                  },
                ),

                // Repost
                ActionButton(
                  icon: Icons.autorenew_rounded,
                  label: _actions.reposts + _actions.quotes,
                  iconColor: _actions.reposted ? Colors.green : color,
                  isActive: _actions.reposted,
                  onPressed: () => options.repostOptions(_actions),
                ),

                // Views
                ActionButton(
                  icon: Icons.remove_red_eye_outlined,
                  label: _actions.views,
                  iconColor: color,
                ),
              ],
            ),

            Spacer(),

            // --- Right group: secondary actions ---
            Row(
              spacing: 12,
              children: [
                ActionButton(
                  icon: _actions.bookmarked
                      ? Icons.bookmark
                      : Icons.bookmark_border_rounded,
                  iconColor: _actions.bookmarked ? Colors.blueAccent : color,
                  // label: saves,
                  isActive: _actions.bookmarked,
                  onPressed: () async {
                    await actrl.toggleBookmark(
                      _actions.target,
                      _actions.pid,
                      active: _actions.bookmarked,
                    );
                    _actions.toggleBookmark();
                  },
                ),

                // Share
                ActionButton(
                  icon: Icons.share,
                  iconColor: color,
                  // label: shares,
                ),
              ],
            ),
            // Save
          ],
        ),
      ),
    );
  }
}
