import 'dart:async';
import 'dart:math' as math;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:semesta/app/functions/format.dart';
import 'package:semesta/app/functions/logger.dart';
import 'package:semesta/core/mixins/repo_mixin.dart';
import 'package:semesta/app/utils/type_def.dart';
import 'package:semesta/core/models/reaction.dart';
import 'package:semesta/core/repositories/generic_repository.dart';

abstract class IRepository<T> extends GenericRepository with RepoMixin<T> {
  Stream<T> stream$(String doc) {
    assert(doc.isNotEmpty, 'Document ID must not be empty');

    return collection(path)
        .doc(doc)
        .snapshots()
        .map<T>((e) {
          if (!e.exists) throw StateError('Document does not exist');

          return from(e.data()!, e.id);
        })
        .handleError((error) {
          // Log error or provide fallback
          HandleLogger.error('Failed to stream data $doc', message: error);
        });
  }

  Stream<Doc<AsMap>> liveStream(String doc) {
    return collection(path).doc(doc).snapshots();
  }

  Stream<bool> has$(String docPath) {
    return document(docPath).snapshots().map((d) => d.exists);
  }

  Future<void> toggleCount(
    String doc, {
    String? col,
    String key = 'posts',
    int delta = 1,
  }) async {
    final ref = collection(col ?? path).doc(doc);
    try {
      await db.runTransaction((txn) async {
        final snap = await txn.get(ref);
        if (!snap.exists) return;

        final value = (snap.data()?['${key}_count'] ?? 0) as num;
        if (value + delta < 0) return;

        txn.update(ref, {'${key}_count': value + delta});
      });
    } catch (e, s) {
      HandleLogger.error('Failed to toggle $key', message: e, stack: s);
      rethrow;
    }
  }

  /// [sdoc] - Source document ID (e.g., user ID)
  /// [edoc] - Edge/target document ID (e.g., post ID)
  /// [key] - The reaction type key (default: 'favorites')
  /// [subcol] - The subcollection name (default: 'favorites')
  Future<void> toggle(
    String sdoc,
    String edoc, {
    String key = 'favorites',
    String subcol = 'favorites',
  }) async {
    final doc = collection(path).doc(sdoc);
    final edgeRef = doc.collection(subcol).doc(edoc);
    final countField = '${key}_count';

    try {
      await db.runTransaction((txn) async {
        // Fetch both documents in parallel for better performance
        final edgeSnap = await txn.get(edgeRef);
        final snap = await txn.get(doc);

        // Validate post document exists
        if (!snap.exists) {
          throw StateError('Document $sdoc does not exist');
        }

        final currentCount = (snap.data()?[countField] as int?) ?? 0;

        if (edgeSnap.exists) {
          // Remove reaction
          txn.delete(edgeRef);
          txn.update(doc, {countField: math.max(0, currentCount - 1)});
        } else {
          // Add reaction
          final reactionData = Reaction(
            currentId: sdoc,
            targetId: edoc,
            createdAt: now,
          ).to();

          txn.set(edgeRef, reactionData);
          txn.update(doc, {countField: currentCount + 1});
        }
      });
    } on FirebaseException catch (e) {
      HandleLogger.error(
        'Failed to toggle $key',
        message: 'Firebase error: ${e.code} - ${e.message}',
      );
      rethrow;
    } catch (e, stackTrace) {
      HandleLogger.error(
        'Failed to toggle $key',
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
  Future<void> subtoggle(
    String sdoc,
    String bdoc,
    String edoc, {
    String key = 'favorites',
    String inSubcol = 'comments',
    String subcol = 'favorites',
  }) async {
    final doc = collection(path).doc(sdoc);
    final nestedRef = doc
        .collection(inSubcol)
        .doc(bdoc)
        .collection(subcol)
        .doc(edoc);
    final countField = '${key}_count';

    try {
      await db.runTransaction((txn) async {
        // Fetch both documents
        final actionSnap = await txn.get(nestedRef);
        final docSnap = await txn.get(doc);

        // Validate source document exists
        if (!docSnap.exists) {
          throw StateError('Document $sdoc does not exist');
        }

        final currentCount = (docSnap.data()?[countField] as int?) ?? 0;

        if (actionSnap.exists) {
          // Remove nested reaction
          txn
            ..delete(nestedRef)
            ..update(doc, {countField: math.max(0, currentCount - 1)});
        } else {
          // Add nested reaction
          final reactionData = NestedReaction(
            currentId: sdoc,
            targetId: edoc,
            betweenId: bdoc,
            createdAt: now,
          ).to();

          txn
            ..set(nestedRef, reactionData)
            ..update(doc, {countField: currentCount + 1});
        }
      });
    } on FirebaseException catch (e) {
      HandleLogger.error(
        'Failed to toggle $key on nested document',
        message: 'Firebase error: ${e.code} - ${e.message}',
      );
      rethrow;
    } catch (e, stackTrace) {
      HandleLogger.error(
        'Failed to toggle $key on nested document',
        message: e,
        stack: stackTrace,
      );
      rethrow;
    }
  }

  Future<List<Reaction>> reactions(
    String col,
    String doc, {
    String key = 'target_id',
    int limit = 30,
  }) {
    assert(
      col.isNotEmpty && doc.isNotEmpty,
      'Collection and Document ID must not be empty',
    );

    return subcollection(col)
        .where(key, isEqualTo: doc)
        .orderBy('created_at', descending: true)
        .limit(limit)
        .get()
        .then((value) {
          return value.docs.map((d) => Reaction.from(d.data())).toList();
        })
        .catchError((error) {
          // Log error or provide fallback
          HandleLogger.error('Failed to list to actions', message: error);

          return <Reaction>[];
        });
  }

  Stream<List<Reaction>> liveReactions$(
    String col,
    String doc, {
    String key = 'target_id',
    int limit = 30,
  }) {
    assert(
      col.isNotEmpty && doc.isNotEmpty,
      'Collection and Document ID must not be empty',
    );

    return subcollection(col)
        .where(key, isEqualTo: doc)
        .orderBy('created_at', descending: true)
        .limit(limit)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) => Reaction.from(doc.data())).toList();
        })
        .handleError((error) {
          // Log error or provide fallback
          HandleLogger.error('Failed to list to actions', message: error);

          return <Reaction>[];
        });
  }

  Future<List<T>> getInOrder(
    AsList values, {
    int limit = 20,
    QueryMode mode = QueryMode.normal,
  }) async {
    if (values.isEmpty) return [];

    final snap = await collection(path)
        .where(FieldPath.documentId, whereIn: values)
        .limit(mode == QueryMode.refresh ? 100 : limit)
        .get();

    final map = {for (var d in snap.docs) d.id: from(d.data(), d.id)};

    // Rebuild list in ACTION order
    return values.where(map.containsKey).map((id) => map[id]!).toList();
  }
}
