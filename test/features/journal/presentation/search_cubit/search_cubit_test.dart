import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mental_health_journal_app/core/errors/failures.dart';
import 'package:mental_health_journal_app/features/journal/domain/entities/journal_entry.dart';
import 'package:mental_health_journal_app/features/journal/domain/use_cases/search_journal_entries.dart';
import 'package:mental_health_journal_app/features/journal/presentation/search_cubit/search_cubit.dart';
import 'package:mocktail/mocktail.dart';

class MockSearchJournalEntries extends Mock implements SearchJournalEntries {}

void main() {
  late SearchJournalEntries searchJournalEntries;

  late SearchCubit cubit;

  setUp(() {
    searchJournalEntries = MockSearchJournalEntries();

    cubit = SearchCubit(searchJournalEntries: searchJournalEntries);
  });

  tearDown(() {
    cubit.close();
  });

  test('given SearchCubit ', () async {
    // Arrange
    // Act
    // Assert
    expect(cubit.state, SearchInitial());
  });

  group('SearchJournalEntries - ', () {
    final testEntries = <JournalEntry>[];
    const query = 'test query';
    final tSearchEntriesFailure = SearchEntriesFailure(
      message: 'message',
      statusCode: 'statusCode',
    );

    blocTest<SearchCubit, SearchState>(
      'given SearchCubit '
      'when [SearchJournalEntries] is called '
      'then emit [SearchingJournal(), EntriesSearched()]',
      build: () {
        when(() => searchJournalEntries(any())).thenAnswer(
          (_) async => Right(testEntries),
        );
        return cubit;
      },
      act: (cubit) => cubit.searchEntries(query),
      expect: () => [
        const SearchingJournal(),
        EntriesSearched(entries: testEntries),
      ],
      verify: (cubit) {
        verify(
          () => searchJournalEntries(query),
        ).called(1);
        verifyNoMoreInteractions(searchJournalEntries);
      },
    );

    blocTest<SearchCubit, SearchState>(
      'given SearchCubit '
      'when [SearchJournalEntries] call is unsuccessful '
      'then emit [SearchingJournal(), SearchError()]',
      build: () {
        when(() => searchJournalEntries(any())).thenAnswer(
          (_) async => Left(tSearchEntriesFailure),
        );
        return cubit;
      },
      act: (cubit) => cubit.searchEntries(query),
      expect: () => [
        const SearchingJournal(),
        SearchError(message: tSearchEntriesFailure.message),
      ],
      verify: (cubit) {
        verify(
          () => searchJournalEntries(query),
        ).called(1);
        verifyNoMoreInteractions(searchJournalEntries);
      },
    );
  });
}
