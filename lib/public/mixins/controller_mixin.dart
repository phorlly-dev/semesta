import 'dart:async';
import 'package:get/get.dart';
import 'package:semesta/public/helpers/cached_helper.dart';
import 'package:semesta/public/helpers/utils_helper.dart';
import 'package:semesta/public/helpers/vendor_helper.dart';
import 'package:semesta/public/mixins/repo_mixin.dart';
import 'package:semesta/app/models/reaction.dart';
import 'package:semesta/public/helpers/generic_helper.dart';
import 'package:semesta/app/controllers/controller.dart';
import 'package:semesta/app/controllers/user_controller.dart';
import 'package:semesta/app/models/author.dart';
import 'package:semesta/app/models/feed.dart';
import 'package:semesta/public/helpers/feed_view.dart';
import 'package:semesta/public/helpers/class_helper.dart';
import 'package:semesta/public/utils/type_def.dart';

mixin ControllerMixin on IController<FeedView> {
  final dataMapping = <String, Feed>{}.obs;
  final uCtrl = Get.put(UserController());

  final Map<String, CachedState<FeedView>> _states = {};
  CachedState<FeedView> stateFor(String key) {
    return _states.putIfAbsent(key, () => CachedState<FeedView>());
  }

  final Map<String, TabMeta> _meta = {};
  TabMeta metaFor(String key) => _meta.putIfAbsent(key, () => TabMeta());

  //User cached
  String get currentUid => uCtrl.currentUid.value;
  bool isCurrentUser(String uid) {
    return currentUser.id.isNotEmpty && currentUid == uid;
  }

  Author get currentUser {
    final currentUser = uCtrl.currentUser.value;
    if (currentUser == null) return Author();

    return uCtrl.currentUser.value!;
  }

  StreamSubscription? _postSub, _commentSub;
  void listenToPost(String pid) {
    if (dataMapping.containsKey(pid)) return;
    _postSub = prepo.sync$(pid).listen((p) => dataMapping[pid] = p);
  }

  void listenToComment(String cid, String pid) {
    if (dataMapping.containsKey(cid)) return;
    _commentSub = prepo
        .sync$('$pid/$comments/$cid')
        .listen((p) => dataMapping[cid] = p);
  }

  void freeOldPosts({int keep = 50}) {
    if (dataMapping.length <= keep) return;

    final keys = dataMapping.keys.toList();
    final removeCount = keys.length - keep;

    for (int i = 0; i < removeCount; i++) {
      final id = keys[i];
      dataMapping.remove(id);
      _postSub?.cancel();
    }
  }

  final _seen = <String>{};
  void markViewed(ActionTarget target) {
    final key = getkey(target);
    if (_seen.contains(key)) return;

    _seen.add(key);

    Future.delayed(
      const Duration(seconds: 2),
      () => prepo.incrementView(target),
    );
  }

  Wait<List<Feed>> getSubcombined(
    List<Reaction> actions, [
    QueryMode mode = QueryMode.normal,
  ]) async {
    final ids = getKeys(actions, (value) => value.currentId);
    final merged = [
      ...await prepo.getInOrder(ids, mode: mode),
      ...await prepo.getInSuborder(ids, mode: mode),
    ].toList();

    if (merged.isEmpty) return const [];
    return merged;
  }

  Wait<List<Feed>> getCombined(
    List<Reaction> actions, [
    QueryMode mode = QueryMode.normal,
  ]) async {
    final ids = getKeys(actions, (value) => value.targetId);
    final merged = [
      ...await prepo.getPosts(ids, mode: mode),
      ...await prepo.getComments(ids, mode: mode),
    ].toList();

    if (merged.isEmpty) return const [];
    return merged;
  }

  Wait<List<Feed>> getMerged(
    String uid, [
    QueryMode mode = QueryMode.normal,
  ]) async {
    final merged = [
      ...await prepo.getPosts(uid, mode: mode),
      ...await prepo.getComments(uid, mode: mode),
    ].toList();

    if (merged.isEmpty) return const [];
    return merged;
  }

  @override
  void onClose() {
    _postSub?.cancel();
    _commentSub?.cancel();
    super.onClose();
  }
}
