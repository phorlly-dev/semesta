import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:semesta/public/extensions/controller_extension.dart';
import 'package:semesta/public/extensions/list_extension.dart';
import 'package:semesta/public/helpers/cached_helper.dart';
import 'package:semesta/public/helpers/feed_view.dart';
import 'package:semesta/public/helpers/generic_helper.dart';
import 'package:semesta/public/mixins/repo_mixin.dart';
import 'package:semesta/public/helpers/utils_helper.dart';
import 'package:semesta/src/components/layout/_page.dart';
import 'package:semesta/src/partials/user_profile.dart';
import 'package:semesta/src/partials/user_comments_tab.dart';
import 'package:semesta/src/partials/user_media_tab.dart';
import 'package:semesta/src/partials/user_posts_tab.dart';
import 'package:semesta/src/widgets/sub/block_overlay.dart';

class ProfilePage extends StatefulWidget {
  final String _uid;
  final bool authed;
  const ProfilePage(this._uid, this.authed, {super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  int _idx = 0;
  String get _uid => widget._uid;
  String get _pKey => getKey(id: _uid, screen: Screen.post);
  String get _cKey => getKey(id: _uid, screen: Screen.comment);
  String get _mKey => getKey(id: _uid, screen: Screen.media);
  CachedState<FeedView> _state(String key) => pctrl.stateFor(key);

  @override
  void initState() {
    pctrl
      ..combinePosts(_uid).then((value) => _state(_pKey).set(value))
      ..combineFeeds(_uid).then((value) => _state(_cKey).set(value));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isLoading = pctrl.isLoading.value;

      return Stack(
        children: [
          PageLayout(
            content: UserProfile(
              _uid,
              initIndex: _idx,
              authed: widget.authed,
              postCount: _state(_cKey).length,
              mediaCount: _state(_mKey).length,
              children: [
                UserPostsTab(_uid),
                UserCommentsTab(_uid),
                UserMediaTab(_uid),
              ],
              onTap: (idx) {
                setState(() => _idx = idx);

                switch (idx) {
                  case 1:
                    final meta = pctrl.metaFor(_cKey);
                    if (meta.dirty) {
                      pctrl.combineFeeds(_uid, QueryMode.refresh).then((value) {
                        _state(_cKey).set(value);
                        meta.dirty = false;
                      });
                    }
                    break;

                  default:
                    final meta = pctrl.metaFor(_pKey);
                    if (meta.dirty) {
                      pctrl.combinePosts(_uid, QueryMode.refresh).then((value) {
                        _state(_pKey).set(value);
                        meta.dirty = false;
                      });
                    }
                }
              },
            ),
          ),

          // ---- overlay ----
          if (isLoading) BlockOverlay('Processing'),
        ],
      );
    });
  }
}
