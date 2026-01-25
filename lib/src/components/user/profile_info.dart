import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:semesta/app/models/author.dart';
import 'package:semesta/public/extensions/extension.dart';
import 'package:semesta/public/helpers/audit_view.dart';
import 'package:semesta/public/helpers/generic_helper.dart';
import 'package:semesta/public/helpers/utils_helper.dart';
import 'package:semesta/public/utils/custom_modal.dart';
import 'package:semesta/public/utils/params.dart';
import 'package:semesta/src/components/user/user_info.dart';
import 'package:semesta/src/widgets/main/action_button.dart';
import 'package:semesta/src/widgets/main/follow_button.dart';
import 'package:semesta/src/widgets/sub/action_count.dart';
import 'package:semesta/src/widgets/sub/custom_text_button.dart';

class ProfileInfo extends StatelessWidget {
  final StatusView _status;
  final CountState _state;
  const ProfileInfo(this._state, this._status, {super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    final user = _status.author;
    final iFollow = _status.iFollow;
    final theyFollow = _status.theyFollow;
    final authed = _status.authed;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        // White background for content
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 32, 12, 8),
          child: _AuthorInfo(user, _state),
        ),

        // Edit / Follow button
        Positioned(
          right: 8,
          child: authed
              ? CustomTextButton(label: 'Edit Profile', onPressed: () {})
              : FollowButton(
                  resolveState(iFollow, theyFollow),
                  onPressed: () async {
                    if (iFollow) {
                      CustomModal(
                        context,
                        title: 'Unfollow ${user.name}?',
                        children: [Text(unfollow)],
                        onConfirm: () async {
                          context.pop();
                          _status.toggle();
                          await actrl.toggleFollow(user.id, iFollow);
                        },
                        label: 'Unfollow',
                        icon: Icons.person_remove_sharp,
                        color: colors.primary,
                      );
                    } else {
                      _status.toggle();
                      await actrl.toggleFollow(user.id, iFollow);
                    }
                  },
                ),
        ),
      ],
    );
  }
}

class _AuthorInfo extends StatelessWidget {
  final Author _user;
  final CountState _state;
  const _AuthorInfo(this._user, this._state);

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DisplayName(_user.name, maxChars: 50),
        Username(_user.uname, maxChars: 60),
        SizedBox(height: 12),

        if (_user.bio.isNotEmpty) Bio(_user.bio),
        SizedBox(height: _user.bio.isEmpty ? 0 : 6),

        Row(
          spacing: 6,
          children: [
            ActionButton(
              sizeIcon: 18,
              textSize: 14,
              iconColor: colors.outline,
              icon: Icons.batch_prediction_rounded,
              label: 'Born ${_user.dob!.toDate}',
            ),

            ActionButton(
              sizeIcon: 18,
              textSize: 14,
              iconColor: colors.outline,
              icon: Icons.calendar_month_outlined,
              label: 'Joined on ${_user.createdAt!.format('MMM yyyy')}',
            ),
          ],
        ),

        SizedBox(height: 6),
        Row(
          spacing: 12,
          children: [
            ActionCount(
              _user.following,
              kind: FeedKind.following,
              onTap: () async {
                await context.openFollow(
                  route.friendship,
                  _user.id,
                  name: _user.name,
                  idx: 1,
                );
              },
            ),

            ActionCount(
              _user.follower,
              kind: FeedKind.follower,
              onTap: () async {
                await context.openFollow(
                  route.friendship,
                  _user.id,
                  name: _user.name,
                  idx: 0,
                );
              },
            ),

            ActionCount(_state.value, kind: _state.kind),
          ],
        ),
      ],
    );
  }
}
