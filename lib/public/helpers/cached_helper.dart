import 'package:semesta/app/controllers/post_controller.dart';
import 'package:semesta/app/models/feed.dart';
import 'package:semesta/app/models/media.dart';
import 'package:semesta/public/extensions/model_extension.dart';
import 'package:semesta/public/functions/logger.dart';
import 'package:semesta/public/helpers/feed_view.dart';
import 'package:semesta/public/helpers/generic_helper.dart';
import 'package:semesta/public/helpers/utils_helper.dart';
import 'package:semesta/public/utils/type_def.dart';

abstract mixin class ICachedHelper {
  /// Deletes thumbnail if it exists
  AsWait _deleteThumbnail(AsList thumbnails) async {
    if (thumbnails.isEmpty) return;

    final path = thumbnails[1];
    if (path.isNotEmpty) await prepo.deleteFile(path);
  }

  /// Deletes a single media file and its thumbnail
  AsWait _deleteSingleMedia(Media media) async {
    try {
      await prepo.deleteFile(media.path);
      await _deleteThumbnail(media.others);
    } catch (e) {
      HandleLogger.error(
        "Failed to delete media file: ${media.path}",
        error: e.toString(),
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

  void clearCached(Feed post, String uid, PostController ctrl) {
    final kh = getKey();
    final kp = getKey(id: uid, screen: Screen.post);
    final kc = getKey(id: uid, screen: Screen.comment);

    switch (post.type) {
      case Create.quote:
        ctrl.metaFor(kh).dirty = true;
        ctrl.metaFor(kp).dirty = true;
        ctrl.metaFor(kc).dirty = true;

        final rid = post.toId(kind: FeedKind.quotes);
        ctrl.clearFor(kh, rid);
        ctrl.clearFor(kp, rid);
        ctrl.clearFor(kc, rid);
        break;

      case Create.reply:
        ctrl.metaFor(kh).dirty = true;
        ctrl.metaFor(kc).dirty = true;

        final rid = post.toId(puid: uid, kind: FeedKind.replies);
        ctrl.clearFor(kh, rid);
        ctrl.clearFor(kc, rid);
        break;

      default:
        ctrl.metaFor(kh).dirty = true;
        ctrl.metaFor(kp).dirty = true;
        ctrl.metaFor(kc).dirty = true;

        final rid = post.toId();
        ctrl.clearFor(kh, rid);
        ctrl.clearFor(kp, rid);
        ctrl.clearFor(kc, rid);
    }
  }

  void editCached(Feed post, String uid, PostController ctrl) {
    final kh = getKey();
    final kp = getKey(id: uid, screen: Screen.post);
    final kc = getKey(id: uid, screen: Screen.comment);

    switch (post.type) {
      case Create.reply:
        ctrl.metaFor(kh).dirty = true;
        ctrl.metaFor(kc).dirty = true;
        break;

      default:
        ctrl.metaFor(kh).dirty = true;
        ctrl.metaFor(kp).dirty = true;
        ctrl.metaFor(kc).dirty = true;
    }
  }
}
