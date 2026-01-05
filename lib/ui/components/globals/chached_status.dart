import 'package:flutter/material.dart';
import 'package:semesta/app/functions/reply_option.dart';
import 'package:semesta/app/utils/type_def.dart';
import 'package:semesta/core/models/feed.dart';
import 'package:semesta/core/models/author.dart';
import 'package:semesta/ui/components/globals/expandable_text.dart';
import 'package:semesta/ui/components/users/user_info.dart';
import 'package:semesta/ui/widgets/animated.dart';
import 'package:semesta/ui/widgets/avatar_animation.dart';

class ChachedStatus extends StatelessWidget {
  final Feed model;
  final Author author;
  final VoidCallback? onProfile, onMenu, onDetail;
  final PropsCallback<String, void>? onExpend;
  const ChachedStatus({
    super.key,
    required this.model,
    required this.author,
    this.onProfile,
    this.onMenu,
    this.onDetail,
    this.onExpend,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final icon = ReplyOption(context).mapToIcon(model.visible);

    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 2, 0, 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // LEFT AVATAR
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: AvatarAnimation(
              imageUrl: author.avatar,
              size: 40,
              onTap: onProfile,
            ),
          ),
          const SizedBox(width: 8),

          // RIGHT CONTENT
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InkWell(
                  onTap: onDetail,
                  child: Row(
                    children: [
                      Animated(
                        onTap: onProfile,
                        child: DisplayName(data: author.name),
                      ),

                      if (author.verified) ...[
                        const SizedBox(width: 4),
                        Icon(Icons.verified, size: 14, color: colors.primary),
                      ],

                      const SizedBox(width: 6),

                      // Username(data: user.username),
                      Status(icon: icon, created: model.createdAt),

                      const Spacer(),

                      // 👇 lightweight menu button
                      InkWell(
                        borderRadius: BorderRadius.circular(20),
                        onTap: onMenu,
                        child: Padding(
                          padding: EdgeInsets.all(4),
                          child: Icon(
                            Icons.more_vert_outlined,
                            size: 20,
                            color: colors.secondary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                if (model.content.isNotEmpty)
                  ExpandableText(
                    text: model.content,
                    trimLength: 120,
                    onTagTap: onExpend,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
