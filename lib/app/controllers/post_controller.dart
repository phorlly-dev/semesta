import 'dart:async';
import 'package:semesta/public/functions/custom_toast.dart';
import 'package:semesta/public/functions/logger.dart';
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

  Future<void> save(Feed model, List<AssetEntity> files) async {
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

  Future<void> saveChange(String pid, AsMap data) async {
    if (pid.isEmpty) return;
    await handleAsync(
      callback: () async {
        await prepo.modify(pid, data);
        CustomToast.info('Post updated.!');
      },
    );
  }

  Future<void> remove(String pid, String uid) async {
    if (pid.isEmpty || uid.isEmpty) return;
    await handleAsync(
      callback: () async {
        final post = dataMapping[pid]!;
        if (post.media.isNotEmpty) {
          for (final m in post.media) {
            try {
              await prepo.deleteFile(m.path);

              final path = m.thumbnails['path'].toString();
              if (m.thumbnails.isNotEmpty && path.isNotEmpty) {
                await prepo.deleteFile(path);
              }
            } catch (e) {
              HandleLogger.error(
                "Failed to delete media file",
                message: e.toString(),
              );
            }
          }
        }

        await prepo.destroy(pid);
        CustomToast.success('Post deleted.!');
      },
    );
  }
}
