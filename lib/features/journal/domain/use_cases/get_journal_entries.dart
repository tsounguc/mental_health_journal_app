import 'package:equatable/equatable.dart';
import 'package:mental_health_journal_app/core/use_case.dart';
import 'package:mental_health_journal_app/core/utils/typedefs.dart';
import 'package:mental_health_journal_app/features/journal/domain/entities/journal_entry.dart';
import 'package:mental_health_journal_app/features/journal/domain/repositories/journal_repository.dart';

class GetJournalEntries extends StreamUseCaseWithParams<List<JournalEntry>, GetJournalEntriesParams> {
  GetJournalEntries(this._repository);

  final JournalRepository _repository;

  @override
  ResultStream<List<JournalEntry>> call(
    GetJournalEntriesParams params,
  ) =>
      _repository.getEntries(
        userId: params.userId,
        lastEntry: params.lastEntry,
        paginationSize: params.paginationSize,
      );
}

class GetJournalEntriesParams extends Equatable {
  const GetJournalEntriesParams({
    required this.userId,
    required this.lastEntry,
    required this.paginationSize,
  });

  const GetJournalEntriesParams.empty()
      : this(
          userId: '_empty.userId',
          lastEntry: null,
          paginationSize: 10,
        );
  final String userId;
  final JournalEntry? lastEntry;
  final int paginationSize;

  @override
  List<Object?> get props => [userId, lastEntry, paginationSize];
}
