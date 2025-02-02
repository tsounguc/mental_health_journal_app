import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart';
import 'package:mental_health_journal_app/core/enums/update_entry_action.dart';
import 'package:mental_health_journal_app/core/errors/exceptions.dart';
import 'package:mental_health_journal_app/core/errors/failures.dart';
import 'package:mental_health_journal_app/core/utils/typedefs.dart';
import 'package:mental_health_journal_app/features/journal/data/data_sources/journal_remote_data_source.dart';
import 'package:mental_health_journal_app/features/journal/data/models/journal_entry_model.dart';
import 'package:mental_health_journal_app/features/journal/domain/entities/journal_entry.dart';
import 'package:mental_health_journal_app/features/journal/domain/repositories/journal_repository.dart';

class JournalRepositoryImpl implements JournalRepository {
  JournalRepositoryImpl(this._remoteDataSource);

  final JournalRemoteDataSource _remoteDataSource;

  @override
  ResultVoid createEntry({
    required JournalEntry entry,
  }) async {
    try {
      final result = await _remoteDataSource.createEntry(entry: entry);
      return Right(result);
    } on CreateEntryException catch (e) {
      return Left(
        CreateEntryFailure.fromException(e),
      );
    }
  }

  @override
  ResultVoid deleteEntry({required String id}) async {
    try {
      final result = await _remoteDataSource.deleteEntry(
        entryId: id,
      );
      return Right(result);
    } on DeleteEntryException catch (e) {
      return Left(
        DeleteEntryFailure.fromException(e),
      );
    }
  }

  @override
  ResultFuture<List<JournalEntry>> searchEntries(String query) async {
    try {
      final result = await _remoteDataSource.searchEntries(query);
      return Right(result);
    } on SearchEntriesException catch (e) {
      return Left(
        SearchEntriesFailure.fromException(e),
      );
    }
  }

  @override
  ResultVoid updateEntry({
    required String entryId,
    required UpdateEntryAction action,
    required dynamic entryData,
  }) async {
    try {
      final result = await _remoteDataSource.updateEntry(
        entryId: entryId,
        action: action,
        entryData: entryData,
      );
      return Right(result);
    } on UpdateEntryException catch (e) {
      return Left(
        UpdateEntryFailure.fromException(e),
      );
    }
  }

  @override
  ResultStream<List<JournalEntry>> getEntries({
    required String userId,
    required JournalEntry? lastEntry,
    required int paginationSize,
  }) {
    return _remoteDataSource
        .getEntries(
          userId: userId,
          lastEntry: lastEntry,
          paginationSize: paginationSize,
        )
        .transform(
          StreamTransformer<List<JournalEntryModel>, Either<Failure, List<JournalEntry>>>.fromHandlers(
            handleData: (entries, sink) {
              sink.add(Right(entries));
            },
            handleError: (error, stackTrace, sink) {
              debugPrintStack(stackTrace: stackTrace, label: error.toString());
              if (error is GetEntriesException) {
                sink.add(Left(GetEntriesFailure.fromException(error)));
              } else {
                sink.add(
                  Left(
                    GetEntriesFailure(
                      message: error.toString(),
                      statusCode: 505,
                    ),
                  ),
                );
              }
            },
          ),
        );
  }

  @override
  ResultStream<List<JournalEntry>> getDashboardData({
    required String userId,
    required DateTime today,
  }) {
    return _remoteDataSource.getDashboardData(userId: userId, today: today).transform(
          StreamTransformer<List<JournalEntryModel>, Either<Failure, List<JournalEntry>>>.fromHandlers(
            handleData: (entries, sink) {
              sink.add(Right(entries));
            },
            handleError: (error, stackTrace, sink) {
              debugPrintStack(stackTrace: stackTrace, label: error.toString());
              if (error is GetDashboardDataException) {
                sink.add(Left(GetDashboardDataFailure.fromException(error)));
              } else {
                sink.add(
                  Left(
                    GetDashboardDataFailure(
                      message: error.toString(),
                      statusCode: 505,
                    ),
                  ),
                );
              }
            },
          ),
        );
  }
}
