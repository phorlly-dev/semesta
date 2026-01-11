import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:semesta/app/extensions/model_extension.dart';
import 'package:semesta/app/functions/option_modal.dart';
import 'package:semesta/app/routes/routes.dart';
import 'package:semesta/core/views/feed_view.dart';
import 'package:semesta/core/views/utils_helper.dart';
import 'package:semesta/ui/components/globals/cached_actions.dart';
import 'package:semesta/ui/components/globals/chached_status.dart';
import 'package:semesta/ui/components/globals/comment_card.dart';
import 'package:semesta/ui/components/posts/post_info.dart';
import 'package:semesta/ui/widgets/break_section.dart';
import 'package:semesta/ui/components/globals/media_gallery.dart';

class PostCard extends StatelessWidget {
  final bool primary;
  final FeedStateView state;
  const PostCard({super.key, required this.state, this.primary = true});

  @override
  Widget build(BuildContext context) {
    final options = OptionModal(context);

    final s = state.status;
    final c = state.content;
    final a = state.actions;

    final model = c.feed;
    final parent = c.parent;
    final media = model.media;

    final author = s.author;
    final actor = c.actor;
    final authed = s.authed;

    final hasParent = parent != null;
    final hasActor = actor != null;

    final quoted = hasParent && hasActor && model.hasQuote;
    final commented = hasParent && model.hasComment && c.allowed;
    final referenced = hasParent && model.hasComment && !c.allowed;

    return Column(
      children: [
        RepostBanner(
          target: a.target,
          uid: c.uid,
          onTap: (id, self) async {
            await _openProfile(context, id, self);
          },
        ),

        if (commented) ...[
          CommentCard(
            feed: parent,
            primary: primary,
            onTap: (uid, self) async {
              await _openProfile(context, uid, self);
            },
          ),
          SizedBox(height: 6),
        ],

        AnimatedBuilder(
          animation: s,
          builder: (context, child) {
            return ChachedStatus(
              model: model,
              author: author,
              status: referenced
                  ? ReplyingTo(
                      uid: parent.uid,
                      onTap: (uid, self) async {
                        await _openProfile(context, uid, self);
                      },
                    )
                  : null,
              onProfile: () async {
                if (!canNavigateTo(author.id, c.uid) && !primary) return;
                await _openProfile(context, author.id, authed);
              },
              onMenu: () {
                if (authed) {
                  options.currentOptions(
                    model,
                    a.target,
                    active: a.bookmarked,
                    primary: primary,
                  );
                } else {
                  options.anotherOptions(
                    model,
                    a.target,
                    status: s,
                    primary: primary,
                    name: author.name,
                    iFollow: s.iFollow,
                    active: a.bookmarked,
                  );
                }
              },
            );
          },
        ),

        if (media.isNotEmpty) MediaGallery(media: media, id: model.id),

        if (quoted)
          DisplayQuoted(quoted: parent, authed: s.authed, actor: actor),

        CachedActions(a),
        const BreakSection(),
      ],
    );
  }

  Future<void> _openProfile(BuildContext context, String uid, bool self) async {
    await context.pushNamed(
      Routes().profile.name,
      pathParameters: {'id': uid},
      queryParameters: {'self': self.toString()},
    );
  }
}
