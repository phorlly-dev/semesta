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
  final pCtrl = Get.put(PostController());
  UserController get uCtrl => pCtrl.uCtrl;

  String get currentUid => pCtrl.currentUid;
  bool currentedUser(String uid) => pCtrl.currentedUser(uid);
  String get _kh => getKey();
  String get _kf => getKey(screen: Screen.following);
  String get _kp => getKey(id: currentUid, screen: Screen.post);
  String get _kl => getKey(id: currentUid, screen: Screen.favorite);
  String get _kb => getKey(id: currentUid, screen: Screen.bookmark);
  String get _kc => getKey(id: currentUid, screen: Screen.comment);

  AsWait toggleFollow(StatusView status) async {
    await uCtrl.toggleFollow(status.author.id);
    if (!status.authed) pCtrl.metaFor(_kf).dirty = true;
  }

  AsWait toggleFavorite(ActionsView actions) async {
    await prepo.toggleReaction(actions.target, currentUid);
    final rid = actions.feed.toId(puid: currentUid, kind: FeedKind.liked);
    if (!actions.favorited) pCtrl.clearFor(_kl, rid);
  }

  AsWait toggleBookmark(ActionsView actions) async {
    await prepo.toggleReaction(actions.target, currentUid, ActionType.save);
    if (actions.bookmarked) {
      CustomToast.info('Added to Saved', title: 'Saved');
    } else {
      final rid = actions.feed.toId(puid: currentUid, kind: FeedKind.saved);
      pCtrl.clearFor(_kb, rid);
      CustomToast.warning('Removed from Saved', title: 'Saved');
    }
  }

  AsWait toggleRepost(ActionsView actions) async {
    await prepo.toggleReaction(actions.target, currentUid, ActionType.repost);
    pCtrl.metaFor(_kf).dirty = true;
    pCtrl.metaFor(_kc).dirty = true;

    if (actions.reposted) {
      pCtrl.addRepostToTabs(_kp, actions.feed);
      pCtrl.addRepostToTabs(_kc, actions.feed);
      CustomToast.info('Added to Posts', title: 'Reposts');
    } else {
      final rid = actions.feed.toId(puid: currentUid, kind: FeedKind.reposted);
      pCtrl.clearFor(_kh, rid);
      pCtrl.clearFor(_kp, rid);
      pCtrl.clearFor(_kc, rid);
      CustomToast.warning('Removed from Posts', title: 'Reposts');
    }
  }
}
