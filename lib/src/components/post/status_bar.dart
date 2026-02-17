import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:semesta/app/models/author.dart';
import 'package:semesta/app/models/feed.dart';
import 'package:semesta/public/extensions/context_extension.dart';
import 'package:semesta/public/extensions/string_extension.dart';
import 'package:semesta/public/helpers/audit_view.dart';
import 'package:semesta/public/helpers/generic_helper.dart';
import 'package:semesta/public/utils/connector.dart';
import 'package:semesta/public/helpers/params_helper.dart';
import 'package:semesta/src/components/global/text_expandable.dart';
import 'package:semesta/src/components/info/data_helper.dart';
import 'package:semesta/src/widgets/main/animated.dart';
import 'package:semesta/src/widgets/sub/animated_avatar.dart';
import 'package:semesta/src/widgets/sub/direction_x.dart';
import 'package:semesta/src/widgets/sub/direction_y.dart';

class StatusBar extends StatelessWidget {
  final String? uid;
  final StatusView _status;
  final ActionsView _actions;
  final Widget? child;
  final bool primary, profiled;
  final double start, end;
  const StatusBar(
    this._status,
    this._actions, {
    super.key,
    this.primary = true,
    this.child,
    this.profiled = false,
    this.start = 50,
    this.end = 360,
    this.uid,
  });

  @override
  Widget build(BuildContext context) {
    final author = _status.author;
    final authed = _status.authed;
    final center = (start * .5) + 1;

    return Stack(
      children: [
        // 1. The Connector Line (Background Layer)
        if (primary)
          Positioned.fill(
            child: CustomPaint(
              painter: Connector(
                Offset(center, start),
                Offset(center, end.h),
                context.dividerColor,
              ),
            ),
          ),

        // 2. The Main Content Row
        DirectionX(
          padding: const EdgeInsets.only(left: 12, right: 8),
          children: [
            AnimatedAvatar(
              MediaSource.network(author.media.url),
              padding: const EdgeInsets.only(top: 6),
              onTap: () async {
                if (profiled && !author.id.canNavigate(uid)) {
                  return;
                }

                await context.openProfile(author.id, authed);
              },
            ),
            const SizedBox(width: 8),

            Expanded(
              child: DirectionY(
                children: _buildItems(
                  context,
                  author,
                  _actions.feed,
                  _status.authed,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  List<Widget> _buildItems(
    BuildContext context,
    Author author,
    Feed model,
    bool authed,
  ) => [
    Animated(
      child: AnimatedBuilder(
        animation: _status,
        builder: (_, child) => DirectionX(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            DisplayName(author.name),

            // const SizedBox(width: 6),
            // Username(author.uname),
            if (author.verified) ...[
              const SizedBox(width: 4),
              Icon(Icons.verified, size: 14, color: context.primaryColor),
            ],

            const SizedBox(width: 6),
            Status(
              icon: context.toIcon(model.visible),
              created: model.createdAt,
            ),

            const Spacer(),
            InkWell(
              borderRadius: BorderRadius.circular(32),
              child: Icon(
                Icons.more_vert_outlined,
                size: 20,
                color: context.secondaryColor,
              ),
              onTap: () {
                if (authed) {
                  context.openCurrent(_actions, profiled: profiled);
                } else {
                  context.openTarget(_status, _actions, profiled: profiled);
                }
              },
            ),
          ],
        ),
      ),
      onTap: () async {
        await context.openById(routes.detail, _actions.pid);
      },
    ),

    ?child,
    if (model.title.isNotEmpty) ...[
      TextExpandable(
        model.title,
        onLink: (value) async {
          if (value.startsWith('@')) {
            await context.openProfile(value, false);
          } else {
            print(value);
          }
        },
      ),

      const SizedBox(height: 8),
    ],
  ];
}
