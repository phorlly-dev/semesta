import 'package:flutter/material.dart';
import 'package:semesta/app/extensions/controller_extension.dart';
import 'package:semesta/app/functions/option_modal.dart';
import 'package:semesta/core/views/generic_helper.dart';
import 'package:semesta/core/models/feed.dart';
import 'package:semesta/core/views/feed_view.dart';
import 'package:semesta/ui/components/globals/cached_actions.dart';
import 'package:semesta/ui/components/globals/chached_status.dart';
import 'package:semesta/ui/components/globals/media_gallery.dart';
import 'package:semesta/ui/components/posts/post_info.dart';

class CommentCard extends StatelessWidget {
  final bool primary;
  final Feed feed;
  final OpenProfile? onTap;
  const CommentCard({
    super.key,
    this.primary = true,
    required this.feed,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final options = OptionModal(context);
    return StreamBuilder<CommentView>(
      stream: actrl.commentSteam$(feed),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const SizedBox.shrink();

        final cmt = snapshot.data!;
        final s = cmt.status;
        final a = cmt.actions;
        final f = cmt.feed;

        final actor = s.author;
        final authed = s.authed;
        final bookmarked = a.bookmarked;
        final iFollow = s.iFollow;
        final media = f.media;

        return Column(
          children: [
            AnimatedBuilder(
              animation: s,
              builder: (context, child) {
                return ChachedStatus(
                  primary: true,
                  model: f,
                  author: actor,
                  onProfile: () async {
                    await onTap?.call(actor.id, authed);
                  },
                  onMenu: () {
                    if (authed) {
                      options.currentOptions(
                        f,
                        a.target,
                        active: bookmarked,
                        primary: !primary,
                      );
                    } else {
                      options.anotherOptions(
                        f,
                        a.target,
                        status: s,
                        iFollow: iFollow,
                        active: bookmarked,
                        name: actor.name,
                        primary: primary,
                      );
                    }
                  },
                );
              },
            ),

            if (media.isNotEmpty) MediaGallery(media: media, id: f.id),

            CachedActions(a),
          ],
        );
      },
    );
  }
}
