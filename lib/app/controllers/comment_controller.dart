import 'package:semesta/public/helpers/cached_helper.dart';
import 'package:semesta/app/controllers/controller.dart';
import 'package:semesta/public/mixins/repo_mixin.dart';
import 'package:semesta/app/models/feed.dart';
import 'package:semesta/public/helpers/generic_helper.dart';

class CommentController extends IController<Feed> {
  final Map<String, CachedState<Feed>> _states = {};
  CachedState<Feed> stateFor(String key) {
    return _states.putIfAbsent(key, () => CachedState<Feed>());
  }

  Future<List<Feed>> loadPostComments(
    String pid, [
    QueryMode mode = QueryMode.normal,
  ]) {
    return prepo.getReplies(pid, mode: mode).then((value) {
      return value.where((element) => element.pid.isNotEmpty).toList();
    });
  }
}
