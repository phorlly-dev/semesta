import 'package:semesta/public/extensions/model_extension.dart';
import 'package:semesta/public/functions/custom_toast.dart';
import 'package:semesta/public/helpers/generic_helper.dart';
import 'package:semesta/public/helpers/cached_helper.dart';
import 'package:semesta/public/utils/type_def.dart';
import 'package:semesta/app/controllers/feed_controller.dart';
import 'package:semesta/app/models/feed.dart';
import 'package:semesta/public/helpers/feed_view.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

class PostController extends IFeedController with ICachedHelper {
  void addRepostToTabs(String key, Feed feed) async {
    final state = stateFor(key);
    final rowId = feed.toId(kind: FeedKind.reposts, puid: currentUid);
    if (state.any((e) => e.currentId == rowId)) return;

    final post = await loadFeed(feed.id);
    if (post == null) return;

    state.insert(0, FeedView(post, rid: rowId, uid: currentUid, created: now));
    state.refresh();
  }

  void clearFor(String key, String rid) {
    final state = stateFor(key);

    state.removeWhere((s) => s.currentId == rid);
    metaFor(key).dirty = true; // next switch triggers refill
    state.refresh(); // notify RxList
  }

  void invalidate(String key) {
    stateFor(key).clear(); // same RxList instance => Obx rebuild
    metaFor(key).dirty = true; // next switch triggers refill
  }

  AsWait save(Feed model, [List<AssetEntity> files = const []]) {
    return handleAsync(() async {
      final user = currentUser;
      final media = await prepo.uploadMedia(currentUid, files);
      final data = model.copyWith(media: media, uid: user.id);

      await prepo.insert(data);
      CustomToast.info('Posted.!');
    }, onError: (err, stx) => CustomToast.error(err.toString()));
  }

  AsWait saveChange(Feed model) => handleAsync(() async {
    await prepo.modifyPost(model);
    editCached(model, currentUid, this);
    CustomToast.info('Post updated.!');
  });

  AsWait remove(Feed model) => handleAsync(() async {
    await prepo.destroyPost(model);
    await deleteMediaFiles(model.media);

    clearCached(model, currentUid, this);
    CustomToast.success('Post deleted!');
  });
}
