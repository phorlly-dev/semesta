import 'package:flutter/material.dart';
import 'package:semesta/app/models/feed.dart';
import 'package:semesta/public/extensions/context_extension.dart';
import 'package:semesta/public/helpers/generic_helper.dart';
import 'package:semesta/public/helpers/params_helper.dart';
import 'package:semesta/src/components/global/text_expandable.dart';
import 'package:semesta/src/components/global/media_gallery.dart';
import 'package:semesta/src/components/info/data_helper.dart';
import 'package:semesta/src/widgets/sub/animated_avatar.dart';
import 'package:semesta/src/widgets/sub/direction_x.dart';
import 'package:semesta/src/widgets/sub/direction_y.dart';

class QuotedContext extends StatelessWidget {
  final Feed _content;
  final ValueChanged<String>? onLink;
  final double start, end;
  const QuotedContext(
    this._content, {
    super.key,
    this.onLink,
    this.start = 56,
    this.end = 12,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: pctrl.loadReference(_content, false),
      builder: (_, snapshot) {
        if (!snapshot.hasData) return const SizedBox.shrink();

        final state = snapshot.data!;
        final parent = state.feed;
        final actor = state.author;

        return DirectionY(
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
                  AnimatedAvatar(
                    MediaSource.network(actor.media.url),
                    size: 32,
                    padding: const EdgeInsets.only(top: 6.0),
                  ),
                  const SizedBox(width: 8),

                  Expanded(
                    child: DirectionY(
                      children: [
                        DirectionX(
                          children: [
                            DisplayName(actor.name),
                            const SizedBox(width: 4),

                            // Username(actor!.uname, maxChars: 32),
                            // SizedBox(width: 4),
                            Status(created: parent.createdAt, hasIcon: false),
                          ],
                        ),

                        if (parent.title.isNotEmpty)
                          TextExpandable(parent.title, onLink: onLink),
                      ],
                    ),
                  ),
                ],
              ),
              onTap: () async {
                await context.openById(routes.detail, parent.id);
              },
            ),

            if (parent.media.isNotEmpty) ...[
              const SizedBox(height: 8),
              MediaGallery(
                parent.media,
                id: parent.id,
                start: 0,
                end: 0,
                ratio: 1.2,
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(12),
                ),
              ),
            ],
          ],
        );
      },
    );
  }
}
