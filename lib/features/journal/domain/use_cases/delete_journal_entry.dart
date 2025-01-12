import 'package:mental_health_journal_app/core/use_case.dart';
import 'package:mental_health_journal_app/core/utils/typedefs.dart';
import 'package:mental_health_journal_app/features/journal/domain/repositories/journal_repository.dart';

class DeleteJournalEntry implements UseCaseWithParams<void, String> {
  DeleteJournalEntry(this._repository);
  final JournalRepository _repository;

  @override
  ResultVoid call(String params) => _repository.deleteEntry(id: params);
}
