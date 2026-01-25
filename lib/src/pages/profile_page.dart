import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:semesta/public/extensions/controller_extension.dart';
import 'package:semesta/public/extensions/list_extension.dart';
import 'package:semesta/public/helpers/generic_helper.dart';
import 'package:semesta/public/mixins/repo_mixin.dart';
import 'package:semesta/public/helpers/utils_helper.dart';
import 'package:semesta/src/components/layout/_layout_page.dart';
import 'package:semesta/src/partials/user_profile.dart';
import 'package:semesta/src/partials/comments_tab.dart';
import 'package:semesta/src/partials/media_tab.dart';
import 'package:semesta/src/partials/posts_tab.dart';
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
  String get _rKey => getKey(id: _uid, screen: Screen.comment);
  String get _mKey => getKey(id: _uid, screen: Screen.media);

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
      final isLoading = pctrl.isLoading.value;

      return Stack(
        children: [
          LayoutPage(
            content: UserProfile(
              uid: _uid,
              initIndex: _idx,
              authed: widget.authed,
              postCount: pCount,
              mediaCount: mCount,
              children: [PostsTab(_uid), CommentsTab(_uid), MediaTab(_uid)],
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
