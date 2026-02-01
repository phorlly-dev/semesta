import 'package:semesta/app/controllers/post_controller.dart';
import 'package:semesta/app/models/feed.dart';
import 'package:semesta/app/models/media.dart';
import 'package:semesta/public/functions/logger.dart';
import 'package:semesta/public/helpers/generic_helper.dart';
import 'package:semesta/public/helpers/utils_helper.dart';
import 'package:semesta/public/utils/type_def.dart';

mixin HelperMixin {
  /// Deletes thumbnail if it exists
  AsWait _deleteThumbnail(AsMap thumbnails) async {
    if (thumbnails.isEmpty) return;

    final path = thumbnails['path'].toString();
    if (path.isNotEmpty) {
      await prepo.deleteFile(path);
    }
  }

  /// Deletes a single media file and its thumbnail
  AsWait _deleteSingleMedia(Media media) async {
    try {
      await prepo.deleteFile(media.path);
      await _deleteThumbnail(media.thumbnails);
    } catch (e) {
      HandleLogger.error(
        "Failed to delete media file: ${media.path}",
        message: e.toString(),
      );
    }
  }

  /// Deletes all media files and their thumbnails
  AsWait deleteMediaFiles(List<Media> mediaList) async {
    if (mediaList.isEmpty) return;

    await Wait.wait(
      mediaList.map((media) => _deleteSingleMedia(media)),
      eagerError: false, // Continue deleting other files even if one fails
    );
  }

  void clearCache(Feed post, String uid, PostController ctrl) {
    final key = getKey();
    final pkey = getKey(id: uid, screen: Screen.post);
    final ckey = getKey(id: uid, screen: Screen.comment);

    switch (post.type) {
      case Create.quote:
        ctrl.metaFor(key).dirty = true;
        ctrl.metaFor(pkey).dirty = true;
        ctrl.metaFor(ckey).dirty = true;

        final rid = getRowId(pid: post.id, kind: FeedKind.quoted);
        ctrl.clearFor(key, rid);
        ctrl.clearFor(pkey, rid);
        ctrl.clearFor(ckey, rid);
        break;

      case Create.reply:
        ctrl.metaFor(key).dirty = true;
        ctrl.metaFor(ckey).dirty = true;

        final rid = getRowId(pid: post.id, uid: uid, kind: FeedKind.replied);
        ctrl.clearFor(key, rid);
        ctrl.clearFor(ckey, rid);
        break;

      default:
        ctrl.metaFor(key).dirty = true;
        ctrl.metaFor(pkey).dirty = true;
        ctrl.metaFor(ckey).dirty = true;

        final rid = getRowId(pid: post.id);
        ctrl.clearFor(key, rid);
        ctrl.clearFor(pkey, rid);
        ctrl.clearFor(ckey, rid);
    }
  }

  void editCache(Feed post, String uid, PostController ctrl) {
    final key = getKey();
    final pkey = getKey(id: uid, screen: Screen.post);
    final ckey = getKey(id: uid, screen: Screen.comment);

    switch (post.type) {
      case Create.reply:
        ctrl.metaFor(key).dirty = true;
        ctrl.metaFor(ckey).dirty = true;
        break;

      default:
        ctrl.metaFor(key).dirty = true;
        ctrl.metaFor(pkey).dirty = true;
        ctrl.metaFor(ckey).dirty = true;
    }
  }
}
