import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:semesta/app/extensions/controller_extension.dart';
import 'package:semesta/app/functions/option_modal.dart';
import 'package:semesta/app/routes/routes.dart';
import 'package:semesta/core/controllers/action_controller.dart';
import 'package:semesta/core/views/feed_view.dart';
import 'package:semesta/ui/components/globals/cached_actions.dart';
import 'package:semesta/ui/components/globals/chached_status.dart';
import 'package:semesta/ui/components/posts/post_info.dart';
import 'package:semesta/ui/components/users/user_info.dart';
import 'package:semesta/ui/widgets/break_section.dart';
import 'package:semesta/ui/components/globals/media_gallery.dart';

class PostCard extends StatelessWidget {
  final FeedStateView vm;
  final bool me;
  const PostCard({super.key, required this.vm, this.me = false});

  @override
  Widget build(BuildContext context) {
    final routes = Routes();
    final options = OptionModal(context);
    final ctrl = Get.find<ActionController>();

    final c = vm.content;
    final s = vm.status;
    final a = vm.actions;

    final model = c.feed;
    final author = s.author;
    final authed = s.authed;
    final iFollow = s.iFollow;

    return Column(
      children: [
        StreamBuilder(
          stream: ctrl.repostStream$(model.id, c.uid),
          builder: (context, snapshot) {
            if (!snapshot.hasData) return const SizedBox.shrink();

            final rxs = snapshot.data!;
            return DisplayRepost(
              displayName: rxs.authed ? 'You' : rxs.name,
              onTap: () async {
                await context.pushNamed(
                  routes.profile.name,
                  pathParameters: {'id': rxs.uid},
                  queryParameters: {'self': rxs.authed.toString()},
                );
              },
            );
          },
        ),

        ChachedStatus(
          model: model,
          author: author,
          onProfile: () async {
            await context.pushNamed(
              routes.profile.name,
              pathParameters: {'id': author.id},
              queryParameters: {'self': authed.toString()},
            );
          },
          onMenu: () {
            if (authed) {
              options.currentOptions(
                model,
                active: a.bookmarked,
                option: model.visible,
                me: me,
              );
            } else {
              options.anotherOptions(
                model,
                iFollow: iFollow,
                active: a.bookmarked,
                name: author.name,
              );
            }
          },
        ),

        if (model.media.isNotEmpty)
          MediaGallery(media: model.media, id: c.currentId),

        if (c.hasQuote && c.parent != null)
          DisplayQuoted(quoted: c.parent!, authed: s.authed, actor: author),

        Padding(
          padding: const EdgeInsetsDirectional.only(
            start: 60,
            end: 12,
            bottom: 8,
            top: 12,
          ),
          child: CachedActions(vm: vm.actions),
        ),

        BreakSection(),
      ],
    );
  }
}
