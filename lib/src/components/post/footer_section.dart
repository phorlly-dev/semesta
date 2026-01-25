import 'package:flutter/material.dart';
import 'package:semesta/public/extensions/extension.dart';
import 'package:semesta/public/functions/option_modal.dart';
import 'package:semesta/public/helpers/audit_view.dart';
import 'package:semesta/public/helpers/generic_helper.dart';
import 'package:semesta/public/helpers/utils_helper.dart';
import 'package:semesta/src/widgets/main/action_button.dart';
import 'package:semesta/src/widgets/sub/action_count.dart';
import 'package:semesta/src/widgets/sub/break_section.dart';

class FooterSection extends StatelessWidget {
  final ActionsView _actions;
  final DateTime? created;
  const FooterSection(this._actions, {super.key, this.created});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final color = Theme.of(context).hintColor;
    final options = OptionModal(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Row(
                spacing: 4,
                children: [
                  Text(
                    '${created?.format('h:mm a · dd MMM yy')}',
                    style: TextStyle(color: colors.outline, fontSize: 15),
                  ),

                  Text('·', style: TextStyle(color: colors.outline)),

                  ActionCount(_actions.views, kind: FeedKind.viewed),
                ],
              ),
            ),
            const BreakSection(),

            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ActionCount(_actions.reposts, kind: FeedKind.reposted),
                  ActionCount(_actions.quotes, kind: FeedKind.quoted),
                  ActionCount(_actions.favorites, kind: FeedKind.liked),
                  ActionCount(_actions.bookmarks, kind: FeedKind.saved),
                ],
              ),
            ),

            const BreakSection(),

            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
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

                  // Repost
                  ActionButton(
                    icon: Icons.autorenew_rounded,
                    iconColor: _actions.reposted ? Colors.green : color,
                    isActive: _actions.reposted,
                    onPressed: () => options.repostOptions(_actions),
                  ),

                  // Like
                  ActionButton(
                    icon: _actions.favorited
                        ? Icons.favorite
                        : Icons.favorite_border,
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

                  ActionButton(
                    icon: _actions.bookmarked
                        ? Icons.bookmark
                        : Icons.bookmark_border_rounded,
                    iconColor: _actions.bookmarked ? Colors.blueAccent : color,
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
                  ActionButton(icon: Icons.share, iconColor: color),
                ],
              ),
            ),
          ],
        ),

        const BreakSection(),
      ],
    );
  }
}
