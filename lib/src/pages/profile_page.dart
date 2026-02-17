import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:semesta/app/models/author.dart';
import 'package:semesta/public/extensions/controller_extension.dart';
import 'package:semesta/public/extensions/array_extension.dart';
import 'package:semesta/public/extensions/string_extension.dart';
import 'package:semesta/public/helpers/feed_view.dart';
import 'package:semesta/public/helpers/generic_helper.dart';
import 'package:semesta/public/mixins/repository_mixin.dart';
import 'package:semesta/public/helpers/utils_helper.dart';
import 'package:semesta/public/utils/type_def.dart';
import 'package:semesta/src/components/global/animated_card.dart';
import 'package:semesta/src/components/layout/_page.dart';
import 'package:semesta/src/components/layout/overlapping.dart';
import 'package:semesta/src/partials/user_profile.dart';
import 'package:semesta/src/partials/user_comments_tab.dart';
import 'package:semesta/src/partials/user_media_tab.dart';
import 'package:semesta/src/partials/user_posts_tab.dart';

class ProfilePage extends StatefulWidget {
  final String _uid;
  final bool authed;
  const ProfilePage(this._uid, this.authed, {super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  int _idx = 0;
  late String _uid;

  @override
  void initState() {
    _initUser();
    super.initState();
  }

  String get _pKey => getKey(id: _uid, screen: Screen.post);
  String get _cKey => getKey(id: _uid, screen: Screen.comment);
  String get _mKey => getKey(id: _uid, screen: Screen.media);
  Cacher<FeedView> _state(String key) => pctrl.stateFor(key);

  Wait<Author?> _initUser() async {
    final uname = widget._uid.normalize();
    final user = await uctrl.loadUser(widget._uid, uname);
    if (user != null) {
      _uid = user.id;
      pctrl
        ..combinePosts(_uid).then((value) => _state(_pKey).set(value))
        ..combineFeeds(_uid).then((value) => _state(_cKey).set(value));
    }

    return user;
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final loading = pctrl.isLoading.value;

      return Overlapping(
        loading: loading,
        message: 'Processing',
        child: PageLayout(
          content: FutureBuilder(
            future: _initUser(),
            builder: (_, snapshot) {
              if (!snapshot.hasData) return const AnimatedCard();

              final data = snapshot.data!;
              final id = data.id;
              final authed = pctrl.currentedUser(id);

              return UserProfile(
                id,
                initIndex: _idx,
                authed: authed,
                postCount: _state(_cKey).length,
                mediaCount: _state(_mKey).length,
                children: [
                  UserPostsTab(id),
                  UserCommentsTab(id),
                  UserMediaTab(id),
                ],
                onTap: (idx) {
                  setState(() => _idx = idx);

                  switch (idx) {
                    case 1:
                      final meta = pctrl.metaFor(_cKey);
                      if (meta.dirty) {
                        pctrl.combineFeeds(id, QueryMode.refresh).then((value) {
                          _state(_cKey).set(value);
                          meta.dirty = false;
                        });
                      }
                      break;

                    default:
                      final meta = pctrl.metaFor(_pKey);
                      if (meta.dirty) {
                        pctrl.combinePosts(id, QueryMode.refresh).then((value) {
                          _state(_pKey).set(value);
                          meta.dirty = false;
                        });
                      }
                  }
                },
              );
            },
          ),
        ),
      );
    });
  }
}
