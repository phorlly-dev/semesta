import 'package:flutter/material.dart';
import 'package:semesta/public/extensions/extension.dart';
import 'package:semesta/public/helpers/generic_helper.dart';
import 'package:semesta/public/helpers/audit_view.dart';
import 'package:semesta/src/widgets/main/action_button.dart';
import 'package:semesta/src/widgets/sub/direction_x.dart';

class ActionsBar extends StatelessWidget {
  final ActionsView _actions;
  final Color? color;
  final double start, end, top, bottom;
  const ActionsBar(
    this._actions, {
    super.key,
    this.start = 56,
    this.end = 12,
    this.top = 12,
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
                color: color ?? context.hintColor,
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
                color: _actions.favorited
                    ? Colors.redAccent
                    : color ?? context.hintColor,
                onPressed: () {
                  _actions.toggleFavorite();
                  actrl.toggleFavorite(
                    _actions.target,
                    _actions.pid,
                    active: _actions.favorited,
                  );
                },
              ),

              // Repost
              ActionButton(
                icon: Icons.autorenew_rounded,
                label: _actions.reposts + _actions.quotes,
                color: _actions.reposted
                    ? Colors.green
                    : color ?? context.hintColor,
                isActive: _actions.reposted,
                onPressed: () => context.open.repostOptions(_actions),
              ),

              // Views
              ActionButton(
                icon: Icons.remove_red_eye_outlined,
                label: _actions.views,
                color: color ?? context.hintColor,
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
                color: _actions.bookmarked
                    ? Colors.blueAccent
                    : color ?? context.hintColor,
                isActive: _actions.bookmarked,
                onPressed: () {
                  actrl.toggleBookmark(
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
                color: color ?? context.hintColor,
              ),
            ],
          ),
          // Save
        ],
      ),
    );
  }
}
