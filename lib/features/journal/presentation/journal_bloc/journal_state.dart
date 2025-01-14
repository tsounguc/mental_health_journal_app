part of 'journal_bloc.dart';

sealed class JournalState extends Equatable {
  const JournalState();

  @override
  List<Object> get props => [];
}

final class JournalInitial extends JournalState {
  const JournalInitial();
}

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
