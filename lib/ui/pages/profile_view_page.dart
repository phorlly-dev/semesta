import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:semesta/app/extensions/controller_extension.dart';
import 'package:semesta/app/extensions/list_extension.dart';
import 'package:semesta/app/utils/params.dart';
import 'package:semesta/core/controllers/post_controller.dart';
import 'package:semesta/core/mixins/repo_mixin.dart';
import 'package:semesta/core/views/helper.dart';
import 'package:semesta/ui/components/users/account_profile.dart';
import 'package:semesta/ui/partials/favorites_tab.dart';
import 'package:semesta/ui/partials/media_tab.dart';
import 'package:semesta/ui/components/layouts/_layout_page.dart';
import 'package:semesta/ui/partials/posts_tab.dart';
import 'package:semesta/ui/partials/comments_tab.dart';

class ProfileViewPage extends StatefulWidget {
  final String uid;
  final bool authed;
  const ProfileViewPage({super.key, required this.uid, required this.authed});

  @override
  State<ProfileViewPage> createState() => _ProfileViewPageState();
}

class _ProfileViewPageState extends State<ProfileViewPage> {
  final _ctrl = Get.find<PostController>();
  CountState _state = CountState('posts', 0);

  @override
  void initState() {
    _loadInit();
    super.initState();
  }

  void _loadInit() {
    // Use addPostFrameCallback instead of microtask for better timing
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      _ctrl.combinePosts(widget.uid).then((value) {
        final state = _ctrl.stateFor('profile:${widget.uid}:posts');
        state.set(value);
        setState(() => _state = countState(state.length));
      });

      _ctrl.loadUserMedia(widget.uid).then((value) {
        _ctrl.stateFor('profile:${widget.uid}:media').set(value);
      });

      _ctrl.loadUserFavorites(widget.uid).then((value) {
        _ctrl.stateFor('profile:${widget.uid}:favorites').set(value);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutPage(
      content: AccountProfile(
        uid: widget.uid,
        state: _state,
        authed: widget.authed,
        children: [
          PostsTab(uid: widget.uid),
          CommentsTab(uid: widget.uid),
          MediaTab(uid: widget.uid),
          if (widget.authed) FavoritesTab(uid: widget.uid),
        ],
        onTap: (idx) {
          switch (idx) {
            case 2:
              final state = _ctrl.stateFor('profile:${widget.uid}:media');
              setState(() {
                _state = countState(state.length, KindTab.media);
              });
            case 3:
              final meta = _ctrl.metaFor('profile:${widget.uid}:favorites');
              final state = _ctrl.stateFor('profile:${widget.uid}:favorites');
              setState(() {
                _state = countState(state.length, KindTab.favorites);
              });

              if (meta.dirty) {
                _ctrl.loadUserFavorites(widget.uid, QueryMode.refresh).then((
                  value,
                ) {
                  state.set(value);
                  meta.dirty = false;
                });
              }
              break;
            default:
              final meta = _ctrl.metaFor('profile:${widget.uid}:posts');
              final state = _ctrl.stateFor('profile:${widget.uid}:posts');
              setState(() => _state = countState(state.length));

              if (meta.dirty) {
                _ctrl.combinePosts(widget.uid, QueryMode.refresh).then((value) {
                  state.set(value);
                  meta.dirty = false;
                });
              }
          }
        },
      ),
    );
  }
}
