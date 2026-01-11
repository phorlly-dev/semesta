import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:semesta/app/extensions/controller_extension.dart';
import 'package:semesta/app/extensions/list_extension.dart';
import 'package:semesta/core/views/generic_helper.dart';
import 'package:semesta/core/mixins/repo_mixin.dart';
import 'package:semesta/core/views/utils_helper.dart';
import 'package:semesta/ui/components/users/account_profile.dart';
import 'package:semesta/ui/partials/favorites_tab.dart';
import 'package:semesta/ui/partials/media_tab.dart';
import 'package:semesta/ui/components/layouts/_layout_page.dart';
import 'package:semesta/ui/partials/posts_tab.dart';
import 'package:semesta/ui/partials/comments_tab.dart';
import 'package:semesta/ui/widgets/block_overlay.dart';

class ProfileViewPage extends StatefulWidget {
  final String uid;
  final bool authed;
  const ProfileViewPage({super.key, required this.uid, required this.authed});

  @override
  State<ProfileViewPage> createState() => _ProfileViewPageState();
}

class _ProfileViewPageState extends State<ProfileViewPage> {
  int _idx = 0;
  String get _uid => widget.uid;
  String get _pKey => getKey(uid: _uid, screen: Screen.post);
  String get _rKey => getKey(uid: _uid, screen: Screen.comment);
  String get _fKey => getKey(uid: _uid, screen: Screen.favorite);
  String get _mKey => getKey(uid: _uid, screen: Screen.media);

  @override
  void initState() {
    pctrl.combineFeeds(_uid).then((value) {
      pctrl.stateFor(_rKey).set(value);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final pCount = pctrl.stateFor(_rKey).length;
      final mCount = pctrl.stateFor(_mKey).length;
      final fCount = pctrl.stateFor(_fKey).length;
      final isLoading = pctrl.isLoading.value;

      return Stack(
        children: [
          LayoutPage(
            content: AccountProfile(
              uid: _uid,
              initIndex: _idx,
              authed: widget.authed,
              postCount: pCount,
              mediaCount: mCount,
              favoriteCount: fCount,
              children: [
                PostsTab(uid: _uid),
                CommentsTab(uid: _uid),
                MediaTab(uid: _uid),
                if (widget.authed) FavoritesTab(uid: _uid),
              ],
              onTap: (idx) {
                setState(() => _idx = idx);

                switch (idx) {
                  case 1:
                    final meta = pctrl.metaFor(_rKey);
                    if (meta.dirty) {
                      pctrl.combineFeeds(_uid, QueryMode.refresh).then((value) {
                        pctrl.stateFor(_rKey).set(value);
                        meta.dirty = false;
                      });
                    }
                    break;

                  case 3:
                    final meta = pctrl.metaFor(_fKey);
                    if (meta.dirty) {
                      pctrl.loadUserFavorites(_uid, QueryMode.refresh).then((
                        value,
                      ) {
                        pctrl.stateFor(_fKey).set(value);
                        meta.dirty = false;
                      });
                    }
                    break;
                  default:
                    final meta = pctrl.metaFor(_pKey);
                    if (meta.dirty) {
                      pctrl.combinePosts(_uid, QueryMode.refresh).then((value) {
                        pctrl.stateFor(_pKey).set(value);
                        meta.dirty = false;
                      });
                    }
                }
              },
            ),
          ),

          // ---- overlay ----
          isLoading ? BlockOverlay('Processing') : SizedBox.shrink(),
        ],
      );
    });
  }
}
