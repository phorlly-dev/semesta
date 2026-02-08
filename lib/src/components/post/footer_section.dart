import 'package:flutter/material.dart';
import 'package:semesta/public/extensions/context_extension.dart';
import 'package:semesta/public/extensions/date_time_extension.dart';
import 'package:semesta/public/helpers/audit_view.dart';
import 'package:semesta/public/helpers/feed_view.dart';
import 'package:semesta/public/helpers/generic_helper.dart';
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
                    '${created?.format('h:mm a · dd MMMM yyyy')}',
                    style: TextStyle(color: context.outlineColor),
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
                  spacing: 12,
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
                    onPressed: () async {
                      await context.openById(routes.comment, _actions.pid);
                    },
                  ),

                  // Repost
                  ActionButton(
                    icon: Icons.autorenew_rounded,
                    iconColor: _actions.reposted ? Colors.redAccent : null,
                    active: _actions.reposted,
                    onPressed: () => context.repost(_actions),
                  ),

                  // Like
                  ActionButton(
                    icon: _actions.favorited
                        ? Icons.favorite
                        : Icons.favorite_border,
                    active: _actions.favorited,
                    iconColor: _actions.favorited ? Colors.redAccent : null,
                    onPressed: () {
                      _actions.toggleFavorite();
                      actrl.toggleFavorite(_actions);
                    },
                  ),

                  ActionButton(
                    icon: _actions.bookmarked
                        ? Icons.bookmark
                        : Icons.bookmark_border_rounded,
                    iconColor: _actions.bookmarked ? Colors.blueAccent : null,
                    active: _actions.bookmarked,
                    onPressed: () {
                      _actions.toggleBookmark();
                      actrl.toggleBookmark(_actions);
                    },
                  ),

                  // Share
                  ActionButton(
                    icon: 'share.png',
                    onPressed: () => context.share(_actions),
                  ),
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
