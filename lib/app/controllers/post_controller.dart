import 'package:semesta/public/functions/custom_toast.dart';
import 'package:semesta/public/helpers/generic_helper.dart';
import 'package:semesta/public/utils/type_def.dart';
import 'package:semesta/app/controllers/feed_controller.dart';
import 'package:semesta/app/models/feed.dart';
import 'package:semesta/public/helpers/feed_view.dart';
import 'package:semesta/public/helpers/utils_helper.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

class PostController extends IFeedController {
  void addRepostToTabs(String key, String pid) {
    final state = stateFor(key);

    final rowId = getRowId(pid: pid, kind: FeedKind.reposted, uid: currentUid);
    if (state.any((e) => e.currentId == rowId)) return;

    final post = dataMapping[pid];
    if (post == null) return;

    state.insert(0, FeedView(post, rid: rowId, uid: currentUid, created: now));

    state.refresh();
  }

  void clearFor(String key, String rid) {
    final state = stateFor(key);

    state.removeWhere((s) => s.currentId == rid);
    state.refresh(); // notify RxList
  }

  void invalidate(String key) {
    stateFor(key).clear(); // same RxList instance => Obx rebuild
    metaFor(key).dirty = true; // next switch triggers refill
  }

  Wait<void> save(Feed model, List<AssetEntity> files) async {
    await handleAsync(
      callback: () async {
        final user = currentUser;
        final media = await prepo.uploadMedia(currentUid, files.toList());
        final data = model.copy(media: media, uid: user.id);

        await prepo.insert(data);
        CustomToast.info('Posted.!');
      },
      onError: (err, stx) => CustomToast.error(err.toString()),
    );
  }

  Wait<void> saveChange(Feed post, AsMap data) async {
    await handleAsync(
      callback: () async {
        await prepo.modifyPost(post, data);
        editCache(post, currentUid, this);
        CustomToast.info('Post updated.!');
      },
    );
  }

  Wait<void> remove(Feed post) async {
    await handleAsync(
      callback: () async {
        await deleteMediaFiles(post.media);
        await prepo.destroyPost(post);

        clearCache(post, currentUid, this);
        CustomToast.success('Post deleted!');
      },
    );
  }
}
