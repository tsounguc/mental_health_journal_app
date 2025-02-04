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

  Future<List<JournalEntry>> searchEntries(String query);

  Stream<List<JournalEntryModel>> getEntries({
    required String userId,
    required JournalEntry? lastEntry,
    required int paginationSize,
  });

  Stream<List<JournalEntryModel>> getDashboardData({
    required String userId,
    required DateTime today,
  });
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

      final entryModel = (entry as JournalEntryModel).copyWith(
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
  Future<List<JournalEntry>> searchEntries(String query) async {
    try {
      final lowerCaseQuery = query.toLowerCase();
      return await _entries
          .where('userId', isEqualTo: _authClient.currentUser!.uid)
          .where(
            'title_lowercase',
            isGreaterThanOrEqualTo: lowerCaseQuery,
          )
          .where(
            'title_lowercase',
            isLessThanOrEqualTo: '$lowerCaseQuery\uf8ff',
          ) // Ensures a partial match
          .limit(25)
          .get()
          .then(
            (value) => value.docs
                .map(
                  (doc) => JournalEntryModel.fromMap(doc.data()),
                )
                .toList(),
          );
    } on FirebaseException catch (e, s) {
      debugPrintStack(stackTrace: s);
      throw SearchEntriesException(
        message: e.message ?? 'Unknown error occurred',
        statusCode: '500',
      );
    } on SearchEntriesException {
      rethrow;
    } catch (e, s) {
      debugPrintStack(stackTrace: s);
      throw SearchEntriesException(message: e.toString(), statusCode: '500');
    }
  }

  @override
  Stream<List<JournalEntryModel>> getEntries({
    required String userId,
    required JournalEntry? lastEntry,
    required int paginationSize,
  }) {
    try {
      var entriesQuery = _entries
          .where('userId', isEqualTo: userId)
          .orderBy(
            'dateCreated',
            descending: true,
          )
          .limit(paginationSize);

      if (lastEntry != null) {
        entriesQuery = entriesQuery.startAfter([lastEntry.dateCreated]);
      }

      final entriesStream = entriesQuery.snapshots().map(
            (snapshot) => snapshot.docs
                .map(
                  (doc) => JournalEntryModel.fromMap(doc.data()),
                )
                .toList(),
          );

      return entriesStream.handleError(_handleStreamError);
    } on FirebaseException catch (e, s) {
      debugPrintStack(stackTrace: s);
      throw GetEntriesException(
        message: e.message ?? 'Unknown error occurred',
        statusCode: '501',
      );
    } on GetEntriesException {
      rethrow;
    } catch (e, s) {
      debugPrintStack(stackTrace: s);
      throw GetEntriesException(
        message: e.toString(),
        statusCode: '505',
      );
    }
  }

  @override
  Stream<List<JournalEntryModel>> getDashboardData({
    required String userId,
    required DateTime today,
  }) {
    try {
      final entriesQuery = _entries
          .where('userId', isEqualTo: userId)
          .where(
            'dateCreated',
            isGreaterThan: Timestamp.fromDate(
              today.copyWith(day: today.day - 7),
            ),
          )
          // .where('dateCreated', isLessThanOrEqualTo: today)
          .orderBy(
            'dateCreated',
            descending: false,
          )
          .limit(50);

      final entriesStream = entriesQuery.snapshots().map(
            (snapshot) => snapshot.docs
                .map(
                  (doc) => JournalEntryModel.fromMap(doc.data()),
                )
                .toList(),
          );

      return entriesStream.handleError(_handleStreamError);
    } on FirebaseException catch (e, s) {
      debugPrintStack(stackTrace: s);
      throw GetDashboardDataException(
        message: e.message ?? 'Unknown error occurred',
        statusCode: '501',
      );
    } on GetEntriesException {
      rethrow;
    } catch (e, s) {
      debugPrintStack(stackTrace: s);
      throw GetDashboardDataException(
        message: e.toString(),
        statusCode: '505',
      );
    }
  }

  void _handleStreamError(dynamic error) {
    if (error is FirebaseException) {
      debugPrintStack(stackTrace: error.stackTrace, label: error.code);
    } else {
      debugPrint(error.toString());
      throw GetEntriesException(
        message: error.toString(),
        statusCode: '505',
      );
    }
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
            'title_lowercase': entryData.toString().toLowerCase(),
          },
        );
      case UpdateEntryAction.content:
        await _updateEntryData(
          id: entryId,
          data: {
            'content': (entryData as Map<String, dynamic>)['content'],
            'sentimentScore': entryData['sentimentScore'],
          },
        );
      case UpdateEntryAction.tags:
        await _updateEntryData(
          id: entryId,
          data: {
            'tags': entryData,
          },
        );
      case UpdateEntryAction.selectedMood:
        await _updateEntryData(
          id: entryId,
          data: {
            'selectedMood': entryData,
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

  CollectionReference<DataMap> get _entries => _firestoreClient.collection(
        FirebaseConstants.entriesCollection,
      );
}
