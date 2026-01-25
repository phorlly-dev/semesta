import 'package:flutter/widgets.dart';
import 'package:semesta/public/helpers/feed_view.dart';
import 'package:semesta/src/components/global/media_gallery.dart';
import 'package:semesta/src/components/post/actions_bar.dart';
import 'package:semesta/src/components/post/status_bar.dart';
import 'package:semesta/src/widgets/sub/break_section.dart';

class CorePostCard extends StatelessWidget {
  final StateView _state;
  final bool primary, profiled;
  final Widget? above, middle, reference;
  const CorePostCard(
    this._state, {
    super.key,
    this.primary = true,
    this.above,
    this.middle,
    this.reference,
    this.profiled = false,
  });

  @override
  Widget build(BuildContext context) {
    final actions = _state.actions;
    final model = actions.feed;
    final media = model.media;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ?above,
        StatusBar(
          _state.status,
          model,
          primary: primary,
          profiled: profiled,
          reference: reference,
          target: actions.target,
          saved: actions.bookmarked,
        ),
        if (media.length > 1) MediaGallery(media: media, id: model.id),

        ?middle,
        ActionsBar(actions),
        const BreakSection(),
      ],
    );
  }
}
