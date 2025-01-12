import 'package:equatable/equatable.dart';
import 'package:mental_health_journal_app/core/enums/update_entry_action.dart';
import 'package:mental_health_journal_app/core/use_case.dart';
import 'package:mental_health_journal_app/core/utils/typedefs.dart';
import 'package:mental_health_journal_app/features/journal/domain/repositories/journal_repository.dart';

class UpdateJournalEntry implements UseCaseWithParams<void, UpdateJournalEntryParams> {
  UpdateJournalEntry(this._repository);
  final JournalRepository _repository;

  @override
  ResultVoid call(UpdateJournalEntryParams params) => _repository.updateEntry(
        entryId: params.entryId,
        action: params.action,
        entryData: params.entryData,
      );
}

class UpdateJournalEntryParams extends Equatable {
  const UpdateJournalEntryParams({
    required this.entryId,
    required this.action,
    required this.entryData,
  });

  const UpdateJournalEntryParams.empty()
      : this(
          entryId: '_empty.entryId',
          action: UpdateEntryAction.content,
          entryData: '_empty.content',
        );
  final String entryId;
  final UpdateEntryAction action;
  final dynamic entryData;

  @override
  List<Object?> get props => [entryId, action, entryData];
}
