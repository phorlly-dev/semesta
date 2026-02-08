import 'package:flutter/material.dart';
import 'package:semesta/app/models/author.dart';
import 'package:semesta/app/models/feed.dart';
import 'package:semesta/public/extensions/context_extension.dart';
import 'package:semesta/public/helpers/generic_helper.dart';
import 'package:semesta/public/helpers/params_helper.dart';
import 'package:semesta/src/components/global/expandable_text.dart';
import 'package:semesta/src/components/global/media_gallery.dart';
import 'package:semesta/src/components/user/user_info.dart';
import 'package:semesta/src/widgets/sub/animated_avatar.dart';
import 'package:semesta/src/widgets/sub/direction_x.dart';
import 'package:semesta/src/widgets/sub/direction_y.dart';

class QuotedContext extends StatelessWidget {
  final Feed? quoted;
  final Author? actor;
  final ValueChanged<String>? onTag;
  final double start, end;
  const QuotedContext({
    super.key,
    this.onTag,
    this.quoted,
    this.actor,
    this.start = 56,
    this.end = 12,
  });

  @override
  Widget build(BuildContext context) {
    return quoted == null || actor == null
        ? const SizedBox.shrink()
        : DirectionY(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade300),
            ),
            margin: EdgeInsetsDirectional.only(start: start, end: end),
            children: [
              InkWell(
                radius: 56,
                child: DirectionX(
                  padding: const EdgeInsets.all(8.0),
                  children: [
                    AvatarAnimation(
                      MediaSource.network(actor!.avatar),
                      size: 32,
                      padding: const EdgeInsets.only(top: 6.0),
                    ),
                    SizedBox(width: 8),

                    Expanded(child: DirectionY(children: _info)),
                  ],
                ),
                onTap: () async {
                  await context.openById(routes.detail, quoted!.id);
                },
              ),

              if (quoted!.media.isNotEmpty) ...[
                SizedBox(height: 8),
                MediaGallery(
                  quoted!.media,
                  id: quoted!.id,
                  start: 0,
                  end: 0,
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(12),
                  ),
                ),
              ],
            ],
          );
  }

  List<Widget> get _info => [
    DirectionX(
      children: [
        DisplayName(actor!.name),
        SizedBox(width: 4),

        // Username(actor!.uname, maxChars: 32),
        // SizedBox(width: 4),
        Status(created: quoted!.createdAt, hasIcon: false),
      ],
    ),

    if (quoted!.title.isNotEmpty)
      ExpandableText(quoted!.title, trimLength: 120, onTag: onTag),
  ];
}
