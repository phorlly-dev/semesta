import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:semesta/app/models/feed.dart';
import 'package:semesta/public/extensions/extension.dart';
import 'package:semesta/public/helpers/audit_view.dart';
import 'package:semesta/public/helpers/class_helper.dart';
import 'package:semesta/public/helpers/generic_helper.dart';
import 'package:semesta/public/helpers/utils_helper.dart';
import 'package:semesta/public/utils/comment_connector.dart';
import 'package:semesta/src/components/global/expandable_text.dart';
import 'package:semesta/src/components/user/user_info.dart';
import 'package:semesta/src/widgets/sub/avatar_animation.dart';
import 'package:semesta/src/widgets/sub/direction_x.dart';
import 'package:semesta/src/widgets/sub/direction_y.dart';

class StatusBar extends StatelessWidget {
  final Feed _model;
  final String? uid;
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
    this.start = 50,
    this.end = 360,
    this.uid,
  });

  @override
  Widget build(BuildContext context) {
    final author = _status.author;
    final authed = _status.authed;

    return Stack(
      children: [
        // 1. The Connector Line (Background Layer)
        if (primary)
          Positioned.fill(
            child: CustomPaint(
              painter: CommentConnector(
                startPoint: Offset(16, start),
                endPoint: Offset(16, end.h),
                lineColor: context.dividerColor,
              ),
            ),
          ),

        // 2. The Main Content Row
        DirectionX(
          padding: const EdgeInsets.only(left: 12, right: 8),
          children: [
            AvatarAnimation(
              author.avatar,
              padding: const EdgeInsets.only(top: 6),
              onTap: () async {
                if (profiled && !canNavigateTo(author.id, uid)) {
                  return;
                }

                await context.openProfile(author.id, authed);
              },
            ),
            const SizedBox(width: 8),

            Expanded(
              child: InkWell(
                radius: 32,
                child: DirectionY(
                  children: [
                    AnimatedBuilder(
                      animation: _status,
                      builder: (_, child) => DirectionX(
                        children: [
                          DisplayName(author.name),
                          const SizedBox(width: 6),

                          Username(author.uname),
                          if (author.verified) ...[
                            const SizedBox(width: 4),
                            Icon(
                              Icons.verified,
                              size: 14,
                              color: context.primaryColor,
                            ),
                          ],

                          const SizedBox(width: 8),
                          Status(
                            icon: context.tap.mapToIcon(_model.visible),
                            created: _model.createdAt,
                          ),

                          const Spacer(),
                          InkWell(
                            borderRadius: BorderRadius.circular(20),
                            child: Icon(
                              Icons.more_vert_outlined,
                              size: 20,
                              color: context.secondaryColor,
                            ),
                            onTap: () {
                              if (authed) {
                                context.open.currentOptions(
                                  _model,
                                  target,
                                  active: saved,
                                  profiled: profiled,
                                );
                              } else {
                                context.open.anotherOptions(
                                  _model,
                                  target,
                                  status: _status,
                                  profiled: profiled,
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
                  ],
                ),
                onTap: () async {
                  await context.openById(route.detail, _model.id);
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}
