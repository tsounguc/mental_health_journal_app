part of 'journal_bloc.dart';

sealed class JournalEvent extends Equatable {
  const JournalEvent();

  @override
  List<Object?> get props => [];
}

class CreateEntryEvent extends JournalEvent {
  const CreateEntryEvent({
    required this.entry,
  });

  final JournalEntry entry;

  @override
  List<Object?> get props => [entry];
}

class DeleteEntryEvent extends JournalEvent {
  const DeleteEntryEvent({
    required this.entryId,
  });

  final String entryId;
}

class UpdateEntryEvent extends JournalEvent {
  const UpdateEntryEvent({
    required this.entryId,
    required this.action,
    required this.entryData,
  });
  final String entryId;
  final UpdateEntryAction action;
  final dynamic entryData;
}
