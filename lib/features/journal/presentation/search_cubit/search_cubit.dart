import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mental_health_journal_app/features/journal/domain/entities/journal_entry.dart';
import 'package:mental_health_journal_app/features/journal/domain/use_cases/search_journal_entries.dart';

part 'search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  SearchCubit({
    required SearchJournalEntries searchJournalEntries,
  })  : _searchJournalEntries = searchJournalEntries,
        super(
          SearchInitial(),
        );

  final SearchJournalEntries _searchJournalEntries;

  Future<void> searchEntries(String query) async {
    if (query.isEmpty) {
      emit(const EntriesSearched(entries: []));
    }

    emit(const SearchingJournal());

    final result = await _searchJournalEntries(query);

    result.fold(
          (failure) => emit(SearchError(message: failure.message)),
          (restaurants) => emit(EntriesSearched(entries: restaurants)),
    );
  }
}
