import 'package:mental_health_journal_app/core/use_case.dart';
import 'package:mental_health_journal_app/core/utils/typedefs.dart';
import 'package:mental_health_journal_app/features/journal/domain/entities/journal_entry.dart';
import 'package:mental_health_journal_app/features/journal/domain/repositories/journal_repository.dart';

class SearchJournalEntries extends UseCaseWithParams<List<JournalEntry>, String> {
  const SearchJournalEntries(this._repository);

  final JournalRepository _repository;

  @override
  ResultFuture<List<JournalEntry>> call(
    String params,
  ) =>
      _repository.searchEntries(params);
}
