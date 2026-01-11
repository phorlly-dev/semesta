import 'dart:async';
import 'dart:math' as math;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:semesta/app/functions/logger.dart';
import 'package:semesta/core/views/generic_helper.dart';
import 'package:semesta/app/utils/type_def.dart';
import 'package:semesta/core/mixins/repo_mixin.dart';
import 'package:semesta/core/models/reaction.dart';
import 'package:semesta/core/repositories/generic_repository.dart';
import 'package:semesta/core/views/utils_helper.dart';

abstract class IRepository<T> extends GenericRepository with RepoMixin<T> {
  /// Add a new document
  Future<String> store(T model) async {
    final docRef = collection(path).doc();
    final newModel = (model as dynamic).copy(id: docRef.id);
    await docRef.set(to(newModel));

    return docRef.id;
  }

  /// Update an existing document
  Future<void> modify(String id, AsMap data) {
    return collection(path).doc(id).update(data);
  }

  /// Delete a document
  Future<void> destroy(String id) => collection(path).doc(id).delete();

  /// [sdoc] - Source document ID (e.g., user ID)
  /// [edoc] - Edge/target document ID (e.g., post ID)
  /// [key] - The reaction type key (default: 'favorites')
  /// [subcol] - The subcollection name (default: 'favorites')
  Future<void> toggle(
    String sdoc,
    String edoc, {
    String key = favorites,
    String subcol = favorites,
    FeedKind kind = FeedKind.favorite,
  }) async {
    final doc = collection(path).doc(sdoc);
    final edgeRef = doc.collection(subcol).doc(edoc);
    final countField = countKey(key);

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
          final reaction = Reaction(
            kind: kind,
            exist: true,
            targetId: edoc,
            createdAt: now,
            currentId: sdoc,
          ).to();

          txn.set(edgeRef, reaction);
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
    String key = favorites,
    String subcol = favorites,
    String inSubcol = comments,
    FeedKind kind = FeedKind.favorite,
  }) async {
    final doc = collection(path).doc(sdoc).collection(inSubcol).doc(bdoc);
    final nestedRef = doc.collection(subcol).doc(edoc);
    final countField = countKey(key);

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
          final reaction = Reaction(
            kind: kind,
            exist: true,
            currentId: bdoc,
            targetId: edoc,
            createdAt: now,
          ).to();

          txn
            ..set(nestedRef, reaction)
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
}
