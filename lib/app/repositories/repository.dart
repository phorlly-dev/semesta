import 'package:semesta/public/helpers/class_helper.dart';
import 'package:semesta/public/helpers/feed_view.dart';
import 'package:semesta/public/helpers/generic_helper.dart';
import 'package:semesta/public/utils/type_def.dart';
import 'package:semesta/public/mixins/repo_mixin.dart';
import 'package:semesta/app/models/reaction.dart';
import 'package:semesta/app/repositories/generic_repository.dart';
import 'package:semesta/public/helpers/utils_helper.dart';

abstract class IRepository<T> extends GenericRepository with RepoMixin<T> {
  /// Add a new document
  Wait<String> store(T model) async {
    final docRef = collection(path).doc();
    final newModel = (model as dynamic).copy(id: docRef.id);
    await docRef.set(to(newModel));

    return docRef.id;
  }

  /// Update an existing document
  AsWait modify(String id, AsMap data) async {
    final ref = collection(path).doc(id);
    await execute((run) async => run.update(ref, data));
  }

  /// Delete a document
  AsWait destroy(String id) async {
    await execute((run) async => run.delete(collection(path).doc(id)));
  }

  AsWait incrementView(ActionTarget target, [String col = comments]) async {
    final ref = collection(path);
    final view = toggleStats(FeedKind.viewed);
    await execute((run) async {
      switch (target) {
        case ParentTarget(:final pid):
          run.update(ref.doc(pid), view);
          break;

        case ChildTarget(:final pid, :final cid):
          run.update(ref.doc(pid).collection(col).doc(cid), view);
          break;
      }
    });
  }

  /// [sdoc] - Source document ID (e.g., user ID)
  /// [edoc] - Edge/target document ID (e.g., post ID)
  /// [kind] - The reaction type key (default: FeedKind.liked)
  /// [subcol] - The subcollection name (default: 'favorites')
  AsWait toggle(
    String sdoc,
    String edoc, {
    String subcol = favorites,
    FeedKind kind = FeedKind.liked,
  }) async {
    final doc = collection(path).doc(sdoc);
    final edgeRef = doc.collection(subcol).doc(edoc);

    await execute((run) async {
      // Fetch both documents in parallel for better performance
      final edgeSnap = await run.get(edgeRef);
      final snap = await run.get(doc);

      // Validate post document exists
      if (!snap.exists) {
        throw StateError('Document $sdoc does not exist');
      }

      if (edgeSnap.exists) {
        // Remove reaction
        run.delete(edgeRef);
        run.update(doc, toggleStats(kind, -1));
      } else {
        // Add reaction
        final payload = Reaction(
          kind: kind,
          targetId: edoc,
          currentId: sdoc,
        ).to();
        run.set(edgeRef, payload);
        run.update(doc, toggleStats(kind));
      }
    });
  }

  /// [sdoc] - Source document ID (e.g., post ID)
  /// [bdoc] - Between/parent document ID (e.g., comment ID)
  /// [edoc] - Edge/target document ID (e.g., user ID performing the action)
  /// [ kind] - The reaction type key (default: FeedKind.liked)
  /// [subcol] - The subcollection name for reactions (default: 'favorites')
  /// [inSubcol] - The intermediate subcollection name (default: 'comments')
  AsWait subtoggle(
    String sdoc,
    String bdoc,
    String edoc, {
    String subcol = favorites,
    String inSubcol = comments,
    FeedKind kind = FeedKind.liked,
  }) async {
    final doc = collection(path).doc(sdoc).collection(inSubcol).doc(bdoc);
    final nestedRef = doc.collection(subcol).doc(edoc);

    await execute((run) async {
      // Fetch both documents
      final docSnap = await run.get(doc);
      final actionSnap = await run.get(nestedRef);

      // Validate source document exists
      if (!docSnap.exists) {
        throw StateError('Document $sdoc does not exist');
      }

      if (actionSnap.exists) {
        // Remove nested reaction
        run.delete(nestedRef);
        run.update(doc, toggleStats(kind, -1));
      } else {
        // Add nested reaction
        final payload = Reaction(
          kind: kind,
          currentId: bdoc,
          targetId: edoc,
        ).to();
        run.set(nestedRef, payload);
        run.update(doc, toggleStats(kind));
      }
    });
  }
}
