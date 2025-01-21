part of 'search_cubit.dart';

sealed class SearchState extends Equatable {
  const SearchState();

  @override
  List<Object> get props => [];
}

final class SearchInitial extends SearchState {

}

final class SearchingJournal extends SearchState {
  const SearchingJournal();
}

final class SearchError extends SearchState {
  const SearchError({
    required this.message,
  });

  final String message;

  @override
  List<Object> get props => [message];
}

final class EntriesSearched extends SearchState {
  const EntriesSearched({
    required this.entries,
  });

  final List<JournalEntry> entries;

  @override
  List<Object> get props => [entries];
}
