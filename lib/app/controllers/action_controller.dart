import 'package:get/get.dart';
import 'package:semesta/public/extensions/model_extension.dart';
import 'package:semesta/public/functions/custom_toast.dart';
import 'package:semesta/public/helpers/audit_view.dart';
import 'package:semesta/public/helpers/feed_view.dart';
import 'package:semesta/public/helpers/generic_helper.dart';
import 'package:semesta/app/controllers/post_controller.dart';
import 'package:semesta/app/controllers/user_controller.dart';
import 'package:semesta/public/helpers/utils_helper.dart';
import 'package:semesta/public/mixins/post_mixin.dart';
import 'package:semesta/public/utils/type_def.dart';

class ActionController extends GetxController {
  ///Playload
  final _pctrl = Get.put(PostController());
  UserController get _uctrl => _pctrl.ctrl;

  String get currentUid => _pctrl.currentUid;
  bool currentedUser(String uid) => _pctrl.currentedUser(uid);
  String get _kh => getKey();
  String get _kf => getKey(screen: Screen.following);
  String get _kp => getKey(id: currentUid, screen: Screen.post);
  String get _kl => getKey(id: currentUid, screen: Screen.favorite);
  String get _kb => getKey(id: currentUid, screen: Screen.bookmark);
  String get _kc => getKey(id: currentUid, screen: Screen.comment);

  AsWait toggleFollow(StatusView status) async {
    await _uctrl.toggleFollow(status.author.id);
    if (!status.authed) _pctrl.metaFor(_kf).dirty = true;
  }

  AsWait toggleFavorite(ActionsView actions) async {
    await prepo.toggleReaction(actions.target);
    final rid = actions.feed.toId(puid: currentUid, kind: FeedKind.likes);
    if (!actions.favorited) _pctrl.clearFor(_kl, rid);
  }

  AsWait toggleBookmark(ActionsView actions) async {
    await prepo.toggleReaction(actions.target, ActionType.save);
    if (actions.bookmarked) {
      CustomToast.info('Added to Saved', title: 'Saved');
    } else {
      final rid = actions.feed.toId(puid: currentUid, kind: FeedKind.saves);
      _pctrl.clearFor(_kb, rid);
      CustomToast.warning('Removed from Saved', title: 'Saved');
    }
  }

  AsWait toggleRepost(ActionsView actions) async {
    await prepo.toggleReaction(actions.target, ActionType.repost);
    _pctrl.metaFor(_kf).dirty = true;
    _pctrl.metaFor(_kc).dirty = true;

    if (actions.reposted) {
      _pctrl.addRepostToTabs(_kp, actions.feed);
      _pctrl.addRepostToTabs(_kc, actions.feed);
      CustomToast.info('Added to Posts', title: 'Reposts');
    } else {
      final rid = actions.feed.toId(puid: currentUid, kind: FeedKind.reposts);
      _pctrl.clearFor(_kh, rid);
      _pctrl.clearFor(_kp, rid);
      _pctrl.clearFor(_kc, rid);
      CustomToast.warning('Removed from Posts', title: 'Reposts');
    }
  }
}
