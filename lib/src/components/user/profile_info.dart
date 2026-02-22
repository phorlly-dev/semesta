import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:semesta/app/models/author.dart';
import 'package:semesta/public/extensions/context_extension.dart';
import 'package:semesta/public/extensions/date_time_extension.dart';
import 'package:semesta/public/extensions/model_extension.dart';
import 'package:semesta/public/helpers/audit_view.dart';
import 'package:semesta/public/helpers/feed_view.dart';
import 'package:semesta/public/helpers/generic_helper.dart';
import 'package:semesta/public/helpers/params_helper.dart';
import 'package:semesta/src/components/info/data_helper.dart';
import 'package:semesta/src/widgets/main/follow_button.dart';
import 'package:semesta/src/widgets/sub/animated_count.dart';
import 'package:semesta/src/widgets/sub/animated_button.dart';
import 'package:semesta/src/widgets/sub/direction_x.dart';
import 'package:semesta/src/widgets/sub/direction_y.dart';

class ProfileInfo extends StatelessWidget {
  final StatusView _status;
  final CountState _count;
  const ProfileInfo(this._count, this._status, {super.key});

  @override
  Widget build(BuildContext context) {
    final user = _status.author;
    final iFollow = _status.iFollow;
    final authed = _status.authed;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        // White background for content
        _AuthorInfo(user, _count),

        // Edit / Follow button
        Positioned(
          right: 8,
          child: authed
              ? AnimatedButton(
                  label: 'Edit Profile',
                  onPressed: () async {
                    await context.openById(routes.edit, user.id);
                  },
                )
              : FollowButton(
                  _status.chekedFollow,
                  onPressed: () {
                    if (iFollow) {
                      context.dialog(
                        title: 'Unfollow ${user.name}?',
                        children: [Text(unfollow)],
                        onConfirm: () {
                          _status.toggle();
                          context.pop();
                          actrl.toggleFollow(_status);
                        },
                        label: 'Unfollow',
                        icon: Icons.person_remove_sharp,
                        color: context.primaryColor,
                      );
                    } else {
                      _status.toggle();
                      actrl.toggleFollow(_status);
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

  ProfileMeta get _meta => ProfileMeta(
    _user.location,
    _user.website,
    joined: _user.createdAt,
    birthdate: _user.birthdate,
  );

  @override
  Widget build(BuildContext context) {
    return DirectionY(
      margin: const EdgeInsets.fromLTRB(16, 32, 12, 8),
      children: [
        DisplayName(_user.name, maxChars: 32),
        Username(_user.uname, maxChars: 36),
        const SizedBox(height: 12),

        if (_user.bio.isNotEmpty) ...[
          Bio(_user.bio, profiled: true),
          const SizedBox(height: 8),
        ],
        Wrap(spacing: 12, runSpacing: 6, children: _metaItems),

        const SizedBox(height: 12),
        DirectionX(spacing: 12, children: _countItems(context)),
      ],
    );
  }

  List<Widget> _countItems(BuildContext context) => [
    AnimatedCount(
      _user.following,
      kind: FeedKind.following,
      onTap: () async {
        await context.openFollow(
          routes.friendship,
          _user.id,
          name: _user.name,
          idx: 1,
        );
      },
    ),

    AnimatedCount(
      _user.followers,
      kind: FeedKind.followers,
      onTap: () async {
        await context.openFollow(
          routes.friendship,
          _user.id,
          name: _user.name,
          idx: 0,
        );
      },
    ),

    if (_state.value > 0) AnimatedCount(_state.value, kind: _state.kind),
  ];

  List<Widget> get _metaItems => [
    if (_meta.location.isNotEmpty)
      MetaItem(Icons.location_on_outlined, _meta.location, size: 18),

    if (_meta.website.isNotEmpty) MetaLink(_meta.website),

    if (_meta.birthdate != null)
      MetaItem(
        Icons.lightbulb_outlined,
        'Born ${_meta.birthdate!.toDate}',
        size: 18,
      ),

    if (_meta.joined != null)
      MetaItem(
        Icons.calendar_month_outlined,
        'Joined ${_meta.joined!.format('MMMM yyyy')}',
      ),

    if (_user.gender != Gender.other)
      MetaItem(Icons.group, toCapitalize(_user.gender.name)),
  ];
}
