part of 'journal_cubit.dart';

sealed class JournalState extends Equatable {
  const JournalState();

  @override
  List<Object> get props => [];
}

final class JournalInitial extends JournalState {}

final class JournalLoading extends JournalState {
  const JournalLoading();
}

final class JournalError extends JournalState {
  const JournalError({
    required this.message,
  });

  final String message;

  @override
  List<Object> get props => [message];
}

final class EntryCreated extends JournalState {
  const EntryCreated();
}

final class EntryDeleted extends JournalState {
  const EntryDeleted();
}

final class EntryUpdated extends JournalState {
  const EntryUpdated();
}

final class EntriesFetched extends JournalState {
  const EntriesFetched({
    required this.entries,
    required this.hasReachedEnd,
  });

  final List<JournalEntry> entries;
  final bool hasReachedEnd;

  @override
  List<Object> get props => [entries, hasReachedEnd];
}
