import 'dart:async';
import 'package:semesta/app/functions/custom_toast.dart';
import 'package:semesta/app/functions/logger.dart';
import 'package:semesta/app/utils/type_def.dart';
import 'package:semesta/core/controllers/feed_controller.dart';
import 'package:semesta/core/models/feed.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

class PostController extends IFeedController {
  Future<void> save(Feed model, List<AssetEntity> files) async {
    await handleAsync(
      callback: () async {
        final user = currentUser;
        final media = await repo.uploadMedia(currentUid, files.toList());
        final data = model.copy(media: media, uid: user.id);

        await repo.insert(data);
        CustomToast.info('Posted.!');
      },
      onError: (err) => CustomToast.error(err.toString()),
    );
  }

  Future<void> saveChange(String pid, AsMap data) async {
    if (pid.isEmpty) return;
    await handleAsync(
      callback: () async {
        await repo.modify(pid, data);
        CustomToast.info('Post updated.!');
      },
    );
  }

  Future<void> remove(String pid, String uid) async {
    if (pid.isEmpty || uid.isEmpty) return;
    await tryCatch(
      callback: () async {
        final post = dataMapping[pid]!;
        if (post.media.isNotEmpty) {
          for (final m in post.media) {
            try {
              await repo.deleteFile(m.path);

              final path = m.thumbnails['path'].toString();
              if (m.thumbnails.isNotEmpty && path.isNotEmpty) {
                await repo.deleteFile(path);
              }
            } catch (e) {
              HandleLogger.error(
                "Failed to delete media file",
                message: e.toString(),
              );
            }
          }
        }

        await repo.destroy(pid);
        await repo.toggleCount(uid, col: 'users', delta: -1);
        CustomToast.success('Post deleted.!');
      },
    );
  }

  Future<void> clearAllBookmarks() async {
    if (currentUid.isEmpty) return;
    await tryCatch(
      callback: () async {
        await repo.clearAllBookmarks(currentUid);
        CustomToast.success('All bookmarks cleared');
      },
    );
  }
}
