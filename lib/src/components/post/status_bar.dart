import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:semesta/app/models/feed.dart';
import 'package:semesta/public/extensions/extension.dart';
import 'package:semesta/public/functions/option_modal.dart';
import 'package:semesta/public/functions/visible_option.dart';
import 'package:semesta/public/helpers/audit_view.dart';
import 'package:semesta/public/helpers/class_helper.dart';
import 'package:semesta/public/helpers/generic_helper.dart';
import 'package:semesta/public/utils/comment_connector.dart';
import 'package:semesta/src/components/global/expandable_text.dart';
import 'package:semesta/src/components/global/media_gallery.dart';
import 'package:semesta/src/components/user/user_info.dart';
import 'package:semesta/src/widgets/sub/avatar_animation.dart';

class StatusBar extends StatelessWidget {
  final Feed _model;
  final StatusView _status;
  final Widget? reference;
  final ActionTarget target;
  final bool primary, saved, profiled;
  final double start, end;
  const StatusBar(
    this._status,
    this._model, {
    super.key,
    this.primary = true,
    this.reference,
    this.saved = false,
    this.profiled = false,
    required this.target,
    this.start = 52,
    this.end = 496,
  });

  @override
  Widget build(BuildContext context) {
    final options = OptionModal(context);
    final colors = Theme.of(context).colorScheme;
    final icon = VisibleOption(context).mapToIcon(_model.visible);
    final dividerColor = Theme.of(context).dividerColor.withValues(alpha: 0.5);

    final author = _status.author;
    final authed = _status.authed;

    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 6, 4, 0),
      child: Stack(
        children: [
          // 1. The Connector Line (Background Layer)
          if (primary)
            Positioned.fill(
              child: CustomPaint(
                painter: CommentConnector(
                  startPoint: Offset(18, start),
                  endPoint: Offset(18, end.h),
                  lineColor: dividerColor,
                ),
              ),
            ),

          // 2. The Main Content Row
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: AvatarAnimation(
                  author.avatar,
                  onTap: () async {
                    if (profiled) return;
                    await context.openProfile(author.id, authed);
                  },
                ),
              ),
              const SizedBox(width: 8),

              Expanded(
                child: InkWell(
                  radius: 32,
                  onTap: () async {
                    await context.openById(route.detail, _model.id);
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AnimatedBuilder(
                        animation: _status,
                        builder: (_, child) => Row(
                          children: [
                            DisplayName(author.name),
                            const SizedBox(width: 6),

                            Username(author.uname),
                            if (author.verified) ...[
                              const SizedBox(width: 4),
                              Icon(
                                Icons.verified,
                                size: 14,
                                color: colors.primary,
                              ),
                            ],
                            const SizedBox(width: 6),
                            Status(icon: icon, created: _model.createdAt),

                            const Spacer(),
                            InkWell(
                              borderRadius: BorderRadius.circular(20),
                              child: Padding(
                                padding: const EdgeInsets.all(4),
                                child: Icon(
                                  Icons.more_vert_outlined,
                                  size: 20,
                                  color: colors.secondary,
                                ),
                              ),
                              onTap: () {
                                if (authed) {
                                  options.currentOptions(
                                    _model,
                                    target,
                                    active: saved,
                                    primary: primary,
                                  );
                                } else {
                                  options.anotherOptions(
                                    _model,
                                    target,
                                    status: _status,
                                    primary: primary,
                                    name: author.name,
                                    iFollow: _status.iFollow,
                                    active: saved,
                                  );
                                }
                              },
                            ),
                          ],
                        ),
                      ),

                      ?reference,
                      if (_model.title.isNotEmpty) ...[
                        ExpandableText(_model.title),
                        const SizedBox(height: 8),
                      ],

                      if (_model.media.length == 1)
                        MediaGallery(
                          media: _model.media,
                          id: _model.id,
                          start: 0,
                          end: 6,
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
