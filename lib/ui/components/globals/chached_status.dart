import 'package:flutter/material.dart';
import 'package:semesta/app/functions/reply_option.dart';
import 'package:semesta/app/utils/comment_connector.dart';
import 'package:semesta/core/models/feed.dart';
import 'package:semesta/core/models/author.dart';
import 'package:semesta/ui/components/globals/expandable_text.dart';
import 'package:semesta/ui/components/users/user_info.dart';
import 'package:semesta/ui/widgets/avatar_animation.dart';

class ChachedStatus extends StatelessWidget {
  final Feed model;
  final Author author;
  final bool primary;
  final Widget? status;
  final VoidCallback? onProfile, onMenu, onDetail;
  final ValueChanged<String>? onTag;
  const ChachedStatus({
    super.key,
    required this.model,
    required this.author,
    this.onProfile,
    this.onMenu,
    this.onTag,
    this.onDetail,
    this.primary = false,
    this.status,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final icon = ReplyOption(context).mapToIcon(model.visible);
    final dividerColor = Theme.of(context).dividerColor.withValues(alpha: 0.5);

    // In a real scenario, these offsets would likely be calculated
    // via GlobalKeys or based on the list index.
    final start = Offset(20, 52); // Relative to Stack top-left
    final end = Offset(20, 496);

    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 2, 0, 8),
      child: Stack(
        children: [
          // 1. The Connector Line (Background Layer)
          if (primary)
            Positioned.fill(
              child: CustomPaint(
                painter: CommentConnector(
                  startPoint: start,
                  endPoint: end,
                  lineColor: dividerColor,
                ),
              ),
            ),

          // 2. The Main Content Row
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: AvatarAnimation(
                  imageUrl: author.avatar,
                  size: 40,
                  onTap: onProfile,
                ),
              ),
              const SizedBox(width: 8),

              Expanded(
                child: InkWell(
                  onTap: onDetail,
                  radius: 32,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          DisplayName(data: author.name),

                          if (author.verified) ...[
                            const SizedBox(width: 4),
                            Icon(
                              Icons.verified,
                              size: 14,
                              color: colors.primary,
                            ),
                          ],
                          const SizedBox(width: 6),

                          Status(icon: icon, created: model.createdAt),
                          const Spacer(),

                          InkWell(
                            borderRadius: BorderRadius.circular(20),
                            onTap: onMenu,
                            child: Padding(
                              padding: const EdgeInsets.all(4),
                              child: Icon(
                                Icons.more_vert_outlined,
                                size: 20,
                                color: colors.secondary,
                              ),
                            ),
                          ),
                        ],
                      ),
                      ?status,

                      if (model.content.isNotEmpty)
                        ExpandableText(
                          text: model.content,
                          trimLength: 120,
                          onTagTap: onTag,
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
