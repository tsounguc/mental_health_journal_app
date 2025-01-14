import 'package:dartz/dartz.dart';
import 'package:mental_health_journal_app/core/enums/update_entry_action.dart';
import 'package:mental_health_journal_app/core/errors/exceptions.dart';
import 'package:mental_health_journal_app/core/errors/failures.dart';
import 'package:mental_health_journal_app/core/utils/typedefs.dart';
import 'package:mental_health_journal_app/features/journal/data/data_sources/journal_remote_data_source.dart';
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
}
