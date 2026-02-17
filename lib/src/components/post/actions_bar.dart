import 'package:flutter/material.dart';
import 'package:semesta/public/extensions/context_extension.dart';
import 'package:semesta/public/helpers/generic_helper.dart';
import 'package:semesta/public/helpers/audit_view.dart';
import 'package:semesta/src/widgets/main/action_button.dart';
import 'package:semesta/src/widgets/sub/direction_x.dart';

class ActionsBar extends StatelessWidget {
  final Color? color;
  final ActionsView _actions;
  final double start, end, top, bottom;
  const ActionsBar(
    this._actions, {
    super.key,
    this.start = 58,
    this.end = 12,
    this.top = 16,
    this.bottom = 6,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _actions,
      builder: (_, child) => DirectionX(
        padding: EdgeInsetsDirectional.fromSTEB(start, top, end, bottom),
        children: [
          // --- Left group: engagement actions ---
          DirectionX(
            spacing: 24,
            children: [
              // Comment
              ActionButton(
                icon: 'comment.png',
                label: _actions.comments,
                iconColor: color,
                textColor: color,
                onPressed: () async {
                  await context.openById(routes.comment, _actions.pid);
                },
              ),

              // Repost
              ActionButton(
                icon: Icons.autorenew_rounded,
                label: _actions.reposts + _actions.quotes,
                textColor: color,
                iconColor: _actions.reposted ? Colors.green : color,
                active: _actions.reposted,
                onPressed: () => context.openRepost(_actions),
              ),

              // Like
              ActionButton(
                icon: _actions.favorited
                    ? Icons.favorite
                    : Icons.favorite_border,
                label: _actions.favorites,
                active: _actions.favorited,
                textColor: color,
                iconColor: _actions.favorited ? Colors.redAccent : color,
                onPressed: () {
                  _actions.toggleFavorite();
                  actrl.toggleFavorite(_actions);
                },
              ),

              // Views
              ActionButton(
                icon: Icons.remove_red_eye_outlined,
                label: _actions.views,
                iconColor: color,
                textColor: color,
              ),
            ],
          ),
          const Spacer(),

          // --- Right group: secondary actions ---
          DirectionX(
            spacing: 12,
            children: [
              ActionButton(
                icon: _actions.bookmarked
                    ? Icons.bookmark
                    : Icons.bookmark_border_rounded,
                textColor: color,
                iconColor: _actions.bookmarked ? Colors.blueAccent : color,
                active: _actions.bookmarked,
                onPressed: () {
                  _actions.toggleBookmark();
                  actrl.toggleBookmark(_actions);
                },
              ),

              // Share
              ActionButton(
                icon: 'share.png',
                iconColor: color,
                textColor: color,
                onPressed: () => context.openShare(_actions),
              ),
            ],
          ),
          // Save
        ],
      ),
    );
  }
}
