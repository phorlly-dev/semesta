import 'dart:async';
import 'package:get/get.dart';
import 'package:semesta/app/utils/cached_helper.dart';
import 'package:semesta/core/mixins/repo_mixin.dart';
import 'package:semesta/core/models/reaction.dart';
import 'package:semesta/core/views/generic_helper.dart';
import 'package:semesta/core/controllers/controller.dart';
import 'package:semesta/core/controllers/user_controller.dart';
import 'package:semesta/core/models/author.dart';
import 'package:semesta/core/models/feed.dart';
import 'package:semesta/core/views/feed_view.dart';
import 'package:semesta/core/views/class_helper.dart';
import 'package:semesta/core/views/utils_helper.dart';

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
    _postSub = prepo.stream$(pid).listen((p) => dataMapping[pid] = p);
  }

  void listenTComment(String cid, String pid) {
    if (dataMapping.containsKey(cid)) return;
    _commentSub = prepo
        .stream$('$pid/$comments/$cid')
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

  Future<List<Feed>> getSubcombined(
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

  Future<List<Feed>> getCombined(
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

  Future<List<Feed>> getMerged(
    String uid, [
    QueryMode mode = QueryMode.normal,
  ]) async {
    final merged = [
      ...await prepo.getPosts(
        uid,
        mode: mode,
        visible: [public, following, 'mentioned'],
      ),
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
