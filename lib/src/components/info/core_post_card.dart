import 'package:flutter/material.dart';
import 'package:semesta/public/extensions/context_extension.dart';
import 'package:semesta/public/helpers/feed_view.dart';
import 'package:semesta/public/helpers/generic_helper.dart';
import 'package:semesta/src/components/global/media_gallery.dart';
import 'package:semesta/src/components/post/actions_bar.dart';
import 'package:semesta/src/components/post/status_bar.dart';
import 'package:semesta/src/widgets/sub/break_section.dart';
import 'package:semesta/src/widgets/sub/direction_y.dart';
import 'package:visibility_detector/visibility_detector.dart';

class CorePostCard extends StatelessWidget {
  final StateView _state;
  final String? uid;
  final bool primary, profiled;
  final Widget? above, middle, reference;
  final double start, end, ratio;
  const CorePostCard(
    this._state, {
    super.key,
    this.primary = false,
    this.above,
    this.middle,
    this.reference,
    this.profiled = false,
    this.start = 50,
    this.end = 360,
    this.uid,
    this.ratio = 1,
  });

  @override
  Widget build(BuildContext context) {
    final actions = _state.actions;
    final model = actions.feed;
    final media = model.media;

    return VisibilityDetector(
      key: ValueKey('view-${model.id}'),
      child: DirectionY(
        children: [
          ?above,
          StatusBar(
            _state.status,
            actions,
            uid: uid,
            end: end,
            start: start,
            primary: primary,
            profiled: profiled,
            child: reference,
          ),

          InkWell(
            child: DirectionY(
              children: [
                if (media.isNotEmpty)
                  MediaGallery(media, id: model.id, ratio: ratio),

                ?middle,
              ],
            ),
            onTap: () async {
              await context.openById(routes.detail, model.id);
            },
          ),
          ActionsBar(actions),

          if (!primary) const BreakSection(),
          const SizedBox(height: 6),
        ],
      ),
      onVisibilityChanged: (info) {
        if (info.visibleFraction > 0.6) {
          pctrl.markViewed(actions.target);
        }
      },
    );
  }
}
