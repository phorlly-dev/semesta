import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:semesta/app/routes/routes.dart';
import 'package:semesta/core/models/author.dart';
import 'package:semesta/core/models/feed.dart';
import 'package:semesta/ui/components/globals/expandable_text.dart';
import 'package:semesta/ui/components/globals/media_gallery.dart';
import 'package:semesta/ui/components/users/user_info.dart';
import 'package:semesta/ui/widgets/animated.dart';
import 'package:semesta/ui/widgets/avatar_animation.dart';

class DisplayQuoted extends StatelessWidget {
  final Feed quoted;
  final Author actor;
  final bool authed;
  const DisplayQuoted({
    super.key,
    required this.quoted,
    this.authed = false,
    required this.actor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsetsDirectional.only(start: 60, end: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AvatarAnimation(
                  imageUrl: actor.avatar,
                  size: 36,
                  onTap: () async {
                    await context.pushNamed(
                      Routes().profile.name,
                      pathParameters: {'id': actor.id},
                      queryParameters: {'self': authed.toString()},
                    );
                  },
                ),
                SizedBox(width: 8),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Animated(
                        onTap: () async {
                          await context.pushNamed(
                            Routes().profile.name,
                            pathParameters: {'id': actor.id},
                            queryParameters: {'self': authed.toString()},
                          );
                        },
                        child: Row(
                          children: [
                            DisplayName(data: actor.name),
                            SizedBox(width: 6),

                            Username(data: actor.uname, maxChars: 32),
                            SizedBox(width: 4),

                            Status(created: quoted.createdAt, hasIcon: false),
                          ],
                        ),
                      ),

                      if (quoted.content.isNotEmpty)
                        ExpandableText(
                          text: quoted.content,
                          trimLength: 120,
                          onTagTap: (value) {},
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          if (quoted.media.isNotEmpty) ...[
            SizedBox(height: 8),
            MediaGallery(
              media: quoted.media,
              id: quoted.id,
              start: 0,
              end: 0,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(12),
                bottomRight: Radius.circular(12),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
