import 'package:flutter/material.dart';
import 'package:semesta/public/extensions/controller_extension.dart';
import 'package:semesta/public/extensions/extension.dart';
import 'package:semesta/public/helpers/audit_view.dart';
import 'package:semesta/public/helpers/class_helper.dart';
import 'package:semesta/public/helpers/generic_helper.dart';
import 'package:semesta/src/widgets/main/animated.dart';

class RepostedBanner extends StatelessWidget {
  final String? uid;
  final ActionTarget _target;
  const RepostedBanner(this._target, {super.key, this.uid});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return StreamBuilder<RepostView>(
      stream: actrl.repostStream$(_target, uid),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const SizedBox.shrink();

        final rxs = snapshot.data!;
        final displayName = rxs.authed ? 'You' : rxs.name;

        return Padding(
          padding: EdgeInsets.only(left: 30, top: 8),
          child: Animated(
            onTap: () async {
              await context.openProfile(rxs.uid, rxs.authed);
            },
            child: Row(
              spacing: 6,
              children: [
                Icon(Icons.autorenew_rounded, color: theme.hintColor),
                Text(
                  '$displayName reposted',
                  style: theme.textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: theme.hintColor,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
