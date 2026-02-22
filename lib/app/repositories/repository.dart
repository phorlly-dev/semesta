import 'package:semesta/public/extensions/route_extension.dart';
import 'package:semesta/public/helpers/class_helper.dart';
import 'package:semesta/public/helpers/feed_view.dart';
import 'package:semesta/public/helpers/generic_helper.dart';
import 'package:semesta/public/utils/type_def.dart';
import 'package:semesta/public/mixins/repository_mixin.dart';
import 'package:semesta/app/models/reaction.dart';
import 'package:semesta/app/repositories/generic_repository.dart';
import 'package:semesta/public/helpers/utils_helper.dart';

abstract class IRepository<T> extends GenericRepository
    with RepositoryMixin<T> {
  /// Add a new document
  Wait<String> store(T model) async {
    final ref = collection(colName).doc();
    final payload = toPayload((model as dynamic).copyWith(id: ref.id));
    await ref.set(payload);

    return ref.id;
  }

  /// Update an existing document
  AsWait update(String id, AsMap data) async {
    await collection(colName).doc(id).update(data);
    clearCached(id);
  }

  /// Delete a document
  AsWait destroy(String id) async {
    await collection(colName).doc(id).delete();
    clearCached(id);
  }

  AsWait incrementView(ActionTarget target, [String col = comments]) async {
    final ref = collection(colName);
    final view = toggleStats(FeedKind.views);

    return switch (target) {
      ParentTarget(:final pid) => await ref.doc(pid).update(view),
      ChildTarget(:final pid, :final cid) =>
        await ref.doc(pid).collection(col).doc(cid).update(view),
    };
  }

  /// [sdoc] - Source document ID (e.g., user ID)
  /// [edoc] - Edge/target document ID (e.g., post ID)
  /// [kind] - The reaction type key (default: FeedKind.likes)
  AsWait toggle(
    String sdoc,
    String edoc, [
    FeedKind kind = FeedKind.likes,
  ]) async {
    final ref = collection(colName).doc(sdoc);
    final sref = ref.collection(kind.name).doc(edoc);

    await execute((run) async {
      // Fetch both documents in parallel for better performance
      final res = await run.get(ref);
      final sres = await run.get(sref);

      // Validate post document exists
      if (!res.exists) {
        throw StateError('Document $sdoc does not exist');
      }

      if (sres.exists) {
        // Remove reaction
        run.delete(sref);
        run.update(ref, toggleStats(kind, -1));
      } else {
        // Add reaction
        final payload = Reaction(
          type: kind.type,
          id: sdoc,
          tid: edoc,
        ).toPayload();

        run.set(sref, payload);
        run.update(ref, toggleStats(kind));
      }
    });
  }

  /// [sdoc] - Source document ID (e.g., post ID)
  /// [bdoc] - Between/parent document ID (e.g., comment ID)
  /// [edoc] - Edge/target document ID (e.g., user ID performing the action)
  /// [ kind] - The reaction type key (default: FeedKind.likes)
  /// [col] - The subcollection name for reactions (default: 'comments')
  AsWait subtoggle(
    String sdoc,
    String bdoc,
    String edoc, {
    String col = comments,
    FeedKind kind = FeedKind.likes,
  }) async {
    final ref = collection(colName).doc(sdoc).collection(col).doc(bdoc);
    final sref = ref.collection(kind.name).doc(edoc);

    await execute((run) async {
      // Fetch both documents
      final res = await run.get(ref);
      final sres = await run.get(sref);

      // Validate source document exists
      if (!res.exists) {
        throw StateError('Document $sdoc does not exist');
      }

      if (sres.exists) {
        // Remove nested reaction
        run.delete(sref);
        run.update(ref, toggleStats(kind, -1));
      } else {
        // Add nested reaction
        final payload = Reaction(
          type: kind.type,
          id: bdoc,
          tid: edoc,
        ).toPayload();

        run.set(sref, payload);
        run.update(ref, toggleStats(kind));
      }
    });
  }
}
