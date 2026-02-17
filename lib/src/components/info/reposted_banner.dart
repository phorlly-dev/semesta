import 'package:flutter/material.dart';
import 'package:semesta/public/extensions/context_extension.dart';
import 'package:semesta/public/helpers/class_helper.dart';
import 'package:semesta/public/helpers/generic_helper.dart';
import 'package:semesta/src/widgets/main/animated.dart';
import 'package:semesta/src/widgets/sub/direction_x.dart';

class RepostedBanner extends StatelessWidget {
  final String? uid;
  final ActionTarget _target;
  const RepostedBanner(this._target, {super.key, this.uid});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: pctrl.loadRepost(_target, uid),
      builder: (_, snapshot) {
        if (!snapshot.hasData) return const SizedBox.shrink();

        final state = snapshot.data!;
        final displayName = state.authed ? 'You' : state.name;
        return Animated(
          child: DirectionX(
            spacing: 6,
            padding: EdgeInsets.only(left: 34, top: 4, bottom: 2),
            children: [
              Icon(Icons.autorenew_rounded, color: context.hintColor, size: 18),
              Text(
                '$displayName reposted',
                style: context.texts.labelLarge?.copyWith(
                  fontWeight: FontWeight.w500,
                  color: context.hintColor,
                ),
              ),
            ],
          ),
          onTap: () async {
            await context.openProfile(state.uid, state.authed);
          },
        );
      },
    );
  }
}
