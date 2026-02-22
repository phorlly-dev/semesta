import 'package:get/get.dart';
import 'package:semesta/public/extensions/array_extension.dart';
import 'package:semesta/public/extensions/model_extension.dart';
import 'package:semesta/public/mixins/repository_mixin.dart';
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
  final ctrl = Get.put(UserController());

  final Mapper<Cacher<FeedView>> _states = {};
  Cacher<FeedView> stateFor(String key) {
    return _states.putIfAbsent(key, () => Cacher<FeedView>());
  }

  final Mapper<TabMeta> _meta = {};
  TabMeta metaFor(String key) => _meta.putIfAbsent(key, () => TabMeta());

  //User cached
  String get currentUid => ctrl.currentUid.value;
  bool currentedUser(String uid) {
    return currentUser.id.isNotEmpty && currentUid == uid;
  }

  Author get currentUser {
    final currentUser = ctrl.currentUser.value;
    if (currentUser == null) return Author();

    return ctrl.currentUser.value!;
  }

  final _seen = <String>{};
  void markViewed(ActionTarget target) {
    final key = target.toKey;
    if (_seen.contains(key)) return;

    _seen.add(key);

    Wait.delayed(const Duration(seconds: 2), () => prepo.incrementView(target));
  }

  Waits<Feed> getSubcombined(
    List<Reaction> actions, [
    QueryMode mode = QueryMode.normal,
  ]) async {
    final keys = actions.toKeys((value) => value.id);
    return [
      ...await prepo.getInOrder(keys, mode: mode),
      ...await prepo.getInSuborder(keys, mode: mode),
    ].toList();
  }

  Waits<Feed> getCombined(
    List<Reaction> actions, [
    QueryMode mode = QueryMode.normal,
  ]) async {
    final keys = actions.toKeys((value) => value.tid);
    return [
      ...await prepo.getPosts(keys, mode: mode),
      ...await prepo.getComments(keys, mode: mode),
    ].toList();
  }

  Waits<Feed> getMerged(String uid, [QueryMode mode = QueryMode.normal]) async {
    return [
      ...await prepo.getPosts(uid, mode: mode),
      ...await prepo.getComments(uid, mode: mode),
    ].toList();
  }
}
