import 'package:flutter/material.dart';
import 'package:semesta/app/models/author.dart';
import 'package:semesta/app/models/feed.dart';
import 'package:semesta/src/components/global/expandable_text.dart';
import 'package:semesta/src/components/global/media_gallery.dart';
import 'package:semesta/src/components/user/user_info.dart';
import 'package:semesta/src/widgets/sub/avatar_animation.dart';

class QuotedContext extends StatelessWidget {
  final Feed quoted;
  final Author actor;
  final bool authed;
  final VoidCallback? onTap;
  final ValueChanged<String>? onTag;
  const QuotedContext({
    super.key,
    required this.quoted,
    this.authed = false,
    required this.actor,
    this.onTap,
    this.onTag,
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
          InkWell(
            radius: 56,
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AvatarAnimation(actor.avatar, size: 32),
                  SizedBox(width: 8),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            DisplayName(actor.name),
                            SizedBox(width: 6),

                            Username(actor.uname, maxChars: 32),
                            SizedBox(width: 4),

                            Status(created: quoted.createdAt, hasIcon: false),
                          ],
                        ),

                        if (quoted.title.isNotEmpty)
                          ExpandableText(
                            quoted.title,
                            trimLength: 120,
                            onTag: onTag,
                          ),
                      ],
                    ),
                  ),
                ],
              ),
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
