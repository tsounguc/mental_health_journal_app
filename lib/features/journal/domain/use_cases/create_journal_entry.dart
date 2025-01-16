import 'package:mental_health_journal_app/core/use_case.dart';
import 'package:mental_health_journal_app/core/utils/typedefs.dart';
import 'package:mental_health_journal_app/features/journal/domain/entities/journal_entry.dart';
import 'package:mental_health_journal_app/features/journal/domain/repositories/journal_repository.dart';

class CreateJournalEntry implements UseCaseWithParams<void, JournalEntry> {
  CreateJournalEntry(this._repository);

  final JournalRepository _repository;

  @override
  ResultVoid call(JournalEntry params) => _repository.createEntry(
        entry: params,
      );
}
