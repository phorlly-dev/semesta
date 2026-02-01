import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:semesta/public/functions/logger.dart';
import 'package:semesta/public/helpers/class_helper.dart';
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
    await collection(path).doc(id).update(data).catchError((e) {
      HandleLogger.error('Failed to update data: $e', message: e);
    });
  }

  /// Delete a document
  AsWait destroy(String id) async {
    await collection(path).doc(id).delete().catchError((e) {
      HandleLogger.error('Failed to delete data: $e', message: e);
    });
  }

  AsWait incrementView(ActionTarget target, [String col = comments]) async {
    try {
      await db.runTransaction((txs) async {
        final ref = collection(path);
        switch (target) {
          case ParentTarget(:final pid):
            txs.update(ref.doc(pid), incrementStat(FeedKind.viewed));
            break;

          case ChildTarget(:final pid, :final cid):
            txs.update(
              ref.doc(pid).collection(col).doc(cid),
              incrementStat(FeedKind.viewed),
            );
            break;
        }
      });
    } catch (e) {
      // Log error or handle appropriately
      HandleLogger.error('Failed to update view count: $e', message: e);
      rethrow; // or handle gracefully
    }
  }

  /// [sdoc] - Source document ID (e.g., user ID)
  /// [edoc] - Edge/target document ID (e.g., post ID)
  /// [key] - The reaction type key (default: 'favorites')
  /// [subcol] - The subcollection name (default: 'favorites')
  AsWait toggle(
    String sdoc,
    String edoc, {
    String subcol = favorites,
    FeedKind kind = FeedKind.liked,
  }) async {
    final doc = collection(path).doc(sdoc);
    final edgeRef = doc.collection(subcol).doc(edoc);

    try {
      await db.runTransaction((txn) async {
        // Fetch both documents in parallel for better performance
        final edgeSnap = await txn.get(edgeRef);
        final snap = await txn.get(doc);

        // Validate post document exists
        if (!snap.exists) {
          throw StateError('Document $sdoc does not exist');
        }

        if (edgeSnap.exists) {
          // Remove reaction
          txn.delete(edgeRef).update(doc, incrementStat(kind, -1));
        } else {
          // Add reaction
          final reaction = Reaction(
            kind: kind,
            exist: true,
            targetId: edoc,
            createdAt: now,
            currentId: sdoc,
          ).to();

          txn.set(edgeRef, reaction).update(doc, incrementStat(kind));
        }
      });
    } on FirebaseException catch (e) {
      HandleLogger.error(
        'Failed to toggle ${kind.name}',
        message: 'Firebase error: ${e.code} - ${e.message}',
      );
      rethrow;
    } catch (e, stackTrace) {
      HandleLogger.error(
        'Failed to toggle ${kind.name}',
        message: e,
        stack: stackTrace,
      );
      rethrow;
    }
  }

  /// [sdoc] - Source document ID (e.g., post ID)
  /// [bdoc] - Between/parent document ID (e.g., comment ID)
  /// [edoc] - Edge/target document ID (e.g., user ID performing the action)
  /// [key] - The reaction type key (default: 'favorites')
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

    try {
      await db.runTransaction((txn) async {
        // Fetch both documents
        final actionSnap = await txn.get(nestedRef);
        final docSnap = await txn.get(doc);

        // Validate source document exists
        if (!docSnap.exists) {
          throw StateError('Document $sdoc does not exist');
        }

        if (actionSnap.exists) {
          // Remove nested reaction
          txn.delete(nestedRef).update(doc, incrementStat(kind, -1));
        } else {
          // Add nested reaction
          final reaction = Reaction(
            kind: kind,
            exist: true,
            currentId: bdoc,
            targetId: edoc,
            createdAt: now,
          ).to();

          txn.set(nestedRef, reaction).update(doc, incrementStat(kind));
        }
      });
    } on FirebaseException catch (e) {
      HandleLogger.error(
        'Failed to toggle ${kind.name} on nested document',
        message: 'Firebase error: ${e.code} - ${e.message}',
      );
      rethrow;
    } catch (e, stackTrace) {
      HandleLogger.error(
        'Failed to toggle ${kind.name} on nested document',
        message: e,
        stack: stackTrace,
      );
      rethrow;
    }
  }
}
