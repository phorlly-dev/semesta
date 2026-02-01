import 'package:flutter/material.dart';
import 'package:semesta/public/extensions/extension.dart';
import 'package:semesta/public/helpers/audit_view.dart';
import 'package:semesta/public/helpers/generic_helper.dart';
import 'package:semesta/public/helpers/utils_helper.dart';
import 'package:semesta/src/widgets/main/action_button.dart';
import 'package:semesta/src/widgets/sub/animated_count.dart';
import 'package:semesta/src/widgets/sub/break_section.dart';
import 'package:semesta/src/widgets/sub/direction_x.dart';
import 'package:semesta/src/widgets/sub/direction_y.dart';

class FooterSection extends StatelessWidget {
  final ActionsView _actions;
  final DateTime? created;
  const FooterSection(this._actions, {super.key, this.created});

  @override
  Widget build(BuildContext context) {
    final has =
        _actions.reposts > 0 ||
        _actions.quotes > 0 ||
        _actions.favorites > 0 ||
        _actions.bookmarks > 0;
    final padding = const EdgeInsets.symmetric(horizontal: 12, vertical: 8);

    return DirectionY(
      children: [
        AnimatedBuilder(
          animation: _actions,
          builder: (_, child) => DirectionY(
            children: [
              DirectionX(
                spacing: 4,
                padding: padding,
                children: [
                  Text(
                    '${created?.format('h:mm a · dd MMM yy')}',
                    style: TextStyle(color: context.outlineColor, fontSize: 15),
                  ),

                  if (_actions.views > 0) ...[
                    Text('·', style: TextStyle(color: context.outlineColor)),

                    AnimatedCount(
                      _actions.views,
                      kind: FeedKind.viewed,
                      detailed: true,
                    ),
                  ],
                ],
              ),
              const BreakSection(),

              if (has) ...[
                DirectionX(
                  spacing: 8,
                  padding: padding,
                  children: [
                    if (_actions.reposts > 0)
                      AnimatedCount(
                        _actions.reposts,
                        kind: FeedKind.reposted,
                        onTap: () {},
                      ),

                    if (_actions.quotes > 0)
                      AnimatedCount(
                        _actions.quotes,
                        kind: FeedKind.quoted,
                        onTap: () {},
                      ),

                    if (_actions.favorites > 0)
                      AnimatedCount(_actions.favorites, kind: FeedKind.liked),

                    if (_actions.bookmarks > 0)
                      AnimatedCount(_actions.bookmarks, kind: FeedKind.saved),
                  ],
                ),

                const BreakSection(),
              ],

              DirectionX(
                padding: padding,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  // Comment
                  ActionButton(
                    icon: 'comment.png',
                    color: context.hintColor,
                    onPressed: () async {
                      await context.openById(route.comment, _actions.pid);
                    },
                  ),

                  // Repost
                  ActionButton(
                    icon: Icons.autorenew_rounded,
                    color: _actions.reposted
                        ? Colors.redAccent
                        : context.hintColor,
                    isActive: _actions.reposted,
                    onPressed: () => context.repost(_actions),
                  ),

                  // Like
                  ActionButton(
                    icon: _actions.favorited
                        ? Icons.favorite
                        : Icons.favorite_border,
                    isActive: _actions.favorited,
                    color: _actions.favorited
                        ? Colors.redAccent
                        : context.hintColor,
                    onPressed: () {
                      _actions.toggleFavorite();
                      actrl.toggleFavorite(
                        _actions.target,
                        _actions.pid,
                        active: _actions.favorited,
                      );
                    },
                  ),

                  ActionButton(
                    icon: _actions.bookmarked
                        ? Icons.bookmark
                        : Icons.bookmark_border_rounded,
                    color: _actions.bookmarked
                        ? Colors.blueAccent
                        : context.hintColor,
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
                  ActionButton(icon: Icons.share, color: context.hintColor),
                ],
              ),
            ],
          ),
        ),

        const BreakSection(),
      ],
    );
  }
}
