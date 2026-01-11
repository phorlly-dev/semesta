import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:semesta/app/functions/option_modal.dart';
import 'package:semesta/core/views/generic_helper.dart';
import 'package:semesta/core/views/audit_view.dart';
import 'package:semesta/ui/widgets/action_button.dart';

class CachedActions extends StatelessWidget {
  final ActionsView actions;
  const CachedActions(this.actions, {super.key});

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
        animation: actions,
        builder: (context, child) {
          return Row(
            children: [
              // --- Left group: engagement actions ---
              Row(
                spacing: 12,
                children: [
                  // Comment
                  ActionButton(
                    icon: 'comment.png',
                    label: actions.comments,
                    iconColor: color,
                    onPressed: () async {
                      await context.pushNamed(
                        route.comment.name,
                        pathParameters: {'id': actions.pid},
                      );
                    },
                  ),

                  // Like
                  ActionButton(
                    icon: actions.favorited
                        ? Icons.favorite
                        : Icons.favorite_border,
                    label: actions.favorites,
                    isActive: actions.favorited,
                    iconColor: actions.favorited ? Colors.redAccent : color,
                    onPressed: () {
                      actrl.toggleFavorite(
                        actions.target,
                        actions.pid,
                        active: actions.favorited,
                      );
                      actions.toggleFavorite();
                    },
                  ),

                  // Repost
                  ActionButton(
                    icon: Icons.autorenew_rounded,
                    label: actions.reposts,
                    iconColor: actions.reposted ? Colors.green : color,
                    isActive: actions.reposted,
                    onPressed: () => options.repostOptions(actions),
                  ),

                  // Views
                  ActionButton(
                    icon: Icons.remove_red_eye_outlined,
                    label: actions.views,
                    iconColor: color,
                  ),
                ],
              ),

              Spacer(),

              // --- Right group: secondary actions ---
              Row(
                spacing: 4,
                children: [
                  ActionButton(
                    icon: actions.bookmarked
                        ? Icons.bookmark
                        : Icons.bookmark_border_rounded,
                    iconColor: actions.bookmarked ? Colors.blueAccent : color,
                    // label: saves,
                    isActive: actions.bookmarked,
                    onPressed: () {
                      actrl.toggleBookmark(
                        actions.target,
                        actions.pid,
                        active: actions.bookmarked,
                      );
                      actions.toggleBookmark();
                    },
                  ),

                  // Share
                  ActionButton(
                    icon: Icons.ios_share_rounded,
                    iconColor: color,
                    // label: shares,
                  ),
                ],
              ),
              // Save
            ],
          );
        },
      ),
    );
  }
}
