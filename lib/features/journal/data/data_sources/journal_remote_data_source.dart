import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mental_health_journal_app/core/enums/update_entry_action.dart';
import 'package:mental_health_journal_app/core/errors/exceptions.dart';
import 'package:mental_health_journal_app/core/utils/firebase_constants.dart';
import 'package:mental_health_journal_app/core/utils/typedefs.dart';
import 'package:mental_health_journal_app/features/journal/data/models/journal_entry_model.dart';
import 'package:mental_health_journal_app/features/journal/domain/entities/journal_entry.dart';

abstract class JournalRemoteDataSource {
  Future<void> createEntry({
    required JournalEntry entry,
  });
  Future<void> updateEntry({
    required String entryId,
    required UpdateEntryAction action,
    required dynamic entryData,
  });

  Future<void> deleteEntry({required String entryId});
}

class JournalRemoteDataSourceImpl implements JournalRemoteDataSource {
  JournalRemoteDataSourceImpl({
    required FirebaseAuth authClient,
    required FirebaseFirestore firestoreClient,
  })  : _authClient = authClient,
        _firestoreClient = firestoreClient;

  final FirebaseFirestore _firestoreClient;
  final FirebaseAuth _authClient;

  @override
  Future<void> createEntry({required JournalEntry entry}) async {
    try {
      final entryDocRef = _entries.doc();

      var entryModel = (entry as JournalEntryModel).copyWith(
        id: entryDocRef.id,
        userId: _authClient.currentUser?.uid,
      );

      final result = entryDocRef.set(entryModel.toMap());

      return result;
    } on FirebaseException catch (e, s) {
      debugPrintStack(stackTrace: s);
      debugPrint(e.message);
      throw CreateEntryException(
        message: e.message ?? 'Error occurred',
        statusCode: e.code,
      );
    } on CreateEntryException {
      rethrow;
    } catch (e, s) {
      debugPrintStack(stackTrace: s);
      debugPrint(e.toString());
      throw CreateEntryException(
        message: e.toString(),
        statusCode: '505',
      );
    }
  }

  @override
  Future<void> deleteEntry({required String entryId}) async {
    return _entries.doc(entryId).delete();
  }

  @override
  Future<void> updateEntry({
    required String entryId,
    required UpdateEntryAction action,
    required dynamic entryData,
  }) async {
    switch (action) {
      case UpdateEntryAction.title:
        await _updateEntryData(
          id: entryId,
          data: {
            'title': entryData,
          },
        );
      case UpdateEntryAction.content:
        await _updateEntryData(
          id: entryId,
          data: {
            'content': entryData,
          },
        );
      case UpdateEntryAction.tags:
        await _updateEntryData(
          id: entryId,
          data: {
            'tags': entryData,
          },
        );
      case UpdateEntryAction.sentiment:
        await _updateEntryData(
          id: entryId,
          data: {
            'sentiment': entryData,
          },
        );
    }
  }

  Future<void> _updateEntryData({
    required String id,
    required DataMap data,
  }) async {
    await _entries.doc(id).update(data);
  }

  CollectionReference<DataMap> get _entries => _firestoreClient.collection(FirebaseConstants.entriesCollection);
}
