import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mental_health_journal_app/core/errors/failures.dart';
import 'package:mental_health_journal_app/features/journal/domain/entities/journal_entry.dart';
import 'package:mental_health_journal_app/features/journal/domain/use_cases/create_journal_entry.dart';
import 'package:mental_health_journal_app/features/journal/domain/use_cases/delete_journal_entry.dart';
import 'package:mental_health_journal_app/features/journal/domain/use_cases/get_journal_entries.dart';
import 'package:mental_health_journal_app/features/journal/domain/use_cases/update_journal_entry.dart';
import 'package:mental_health_journal_app/features/journal/presentation/journal_cubit/journal_cubit.dart';
import 'package:mocktail/mocktail.dart';

class MockCreateJournalEntry extends Mock implements CreateJournalEntry {}

class MockDeleteJournalEntry extends Mock implements DeleteJournalEntry {}

class MockUpdateJournalEntry extends Mock implements UpdateJournalEntry {}

class MockGetJournalEntries extends Mock implements GetJournalEntries {}

void main() {
  late CreateJournalEntry createJournalEntry;
  late DeleteJournalEntry deleteJournalEntry;
  late UpdateJournalEntry updateJournalEntry;
  late GetJournalEntries getJournalEntries;

  late JournalCubit cubit;

  final testEntry = JournalEntry.empty();

  setUp(() {
    createJournalEntry = MockCreateJournalEntry();
    deleteJournalEntry = MockDeleteJournalEntry();
    updateJournalEntry = MockUpdateJournalEntry();
    getJournalEntries = MockGetJournalEntries();

    cubit = JournalCubit(
      createJournalEntry: createJournalEntry,
      deleteJournalEntry: deleteJournalEntry,
      updateJournalEntry: updateJournalEntry,
      getJournalEntries: getJournalEntries,
    );
  });

  late UpdateJournalEntryParams tUpdateJournalEntryParams;
  late GetJournalEntriesParams tGetJournalEntriesParams;

  setUpAll(() {
    tUpdateJournalEntryParams = const UpdateJournalEntryParams.empty();
    tGetJournalEntriesParams = const GetJournalEntriesParams.empty();
    registerFallbackValue(tUpdateJournalEntryParams);
    registerFallbackValue(tGetJournalEntriesParams);
    registerFallbackValue(testEntry);
  });

  tearDown(() {
    cubit.close();
  });

  test(
    'given JournalCubit '
    'when bloc is instantiated '
    'then initial state should be [JournalInitial]',
    () async {
      // Arrange
      // Act
      // Assert
      expect(cubit.state, JournalInitial());
    },
  );

  group('CreateJournalEntry - ', () {
    final tCreateEntryFailure = CreateEntryFailure(
      message: 'message',
      statusCode: 500,
    );
    blocTest<JournalCubit, JournalState>(
      'given JournalCubit '
      'when [CreateJournalEntry] is called '
      'then emit [JournalLoading, EntryCreated]',
      build: () {
        when(
          () => createJournalEntry(any()),
        ).thenAnswer((_) async => const Right(null));
        return cubit;
      },
      act: (cubit) => cubit.createEntry(
        entry: testEntry,
      ),
      expect: () => [
        const JournalLoading(),
        const EntryCreated(),
      ],
      verify: (cubit) {
        verify(
          () => createJournalEntry(testEntry),
        ).called(1);
        verifyNoMoreInteractions(createJournalEntry);
      },
    );

    blocTest<JournalCubit, JournalState>(
      'given JournalCubit '
      'when [CreateJournalEntry] call is unsuccessful '
      'then emit [JournalLoading, JournalError]',
      build: () {
        when(
          () => createJournalEntry(any()),
        ).thenAnswer((_) async => Left(tCreateEntryFailure));
        return cubit;
      },
      act: (cubit) => cubit.createEntry(
        entry: testEntry,
      ),
      expect: () => [
        const JournalLoading(),
        JournalError(message: tCreateEntryFailure.message),
      ],
      verify: (bloc) {
        verify(
          () => createJournalEntry(testEntry),
        ).called(1);
        verifyNoMoreInteractions(createJournalEntry);
      },
    );
  });

  group('DeleteJournalEntry - ', () {
    final tDeleteEntryFailure = DeleteEntryFailure(
      message: 'message',
      statusCode: 500,
    );
    blocTest<JournalCubit, JournalState>(
      'given JournalCubit '
      'when [DeleteJournalEntry] is called '
      'then emit [JournalLoading, EntryDeleted]',
      build: () {
        when(
          () => deleteJournalEntry(any()),
        ).thenAnswer((_) async => const Right(null));
        return cubit;
      },
      act: (cubit) => cubit.deleteEntry(
        entryId: testEntry.id,
      ),
      expect: () => [
        const JournalLoading(),
        const EntryDeleted(),
      ],
      verify: (bloc) {
        verify(
          () => deleteJournalEntry(testEntry.id),
        ).called(1);
        verifyNoMoreInteractions(createJournalEntry);
      },
    );

    blocTest<JournalCubit, JournalState>(
      'given JournalCubit '
      'when [DeleteJournalEntry] call is unsuccessful '
      'then emit [JournalLoading, JournalError]',
      build: () {
        when(
          () => deleteJournalEntry(any()),
        ).thenAnswer((_) async => Left(tDeleteEntryFailure));
        return cubit;
      },
      act: (cubit) => cubit.deleteEntry(
        entryId: testEntry.id,
      ),
      expect: () => [
        const JournalLoading(),
        JournalError(message: tDeleteEntryFailure.message),
      ],
      verify: (cubit) {
        verify(
          () => deleteJournalEntry(testEntry.id),
        ).called(1);
        verifyNoMoreInteractions(deleteJournalEntry);
      },
    );
  });

  group('UpdateJournalEntry - ', () {
    final tUpdateEntryFailure = CreateEntryFailure(
      message: 'message',
      statusCode: 500,
    );
    blocTest<JournalCubit, JournalState>(
      'given JournalBloc '
      'when [UpdateJournalEntry] is called '
      'then emit [JournalLoading, EntryUpdated]',
      build: () {
        when(
          () => updateJournalEntry(any()),
        ).thenAnswer((_) async => const Right(null));
        return cubit;
      },
      act: (cubit) => cubit.updateEntry(
        entryId: tUpdateJournalEntryParams.entryId,
        action: tUpdateJournalEntryParams.action,
        entryData: tUpdateJournalEntryParams.entryData,
      ),
      expect: () => [
        const JournalLoading(),
        const EntryUpdated(),
      ],
      verify: (cubit) {
        verify(
          () => updateJournalEntry(tUpdateJournalEntryParams),
        ).called(1);
        verifyNoMoreInteractions(updateJournalEntry);
      },
    );

    blocTest<JournalCubit, JournalState>(
      'given JournalCubit '
      'when [UpdateJournalEntry] call is unsuccessful '
      'then emit [JournalLoading, JournalError]',
      build: () {
        when(
          () => updateJournalEntry(any()),
        ).thenAnswer((_) async => Left(tUpdateEntryFailure));
        return cubit;
      },
      act: (cubit) => cubit.updateEntry(
        entryId: tUpdateJournalEntryParams.entryId,
        action: tUpdateJournalEntryParams.action,
        entryData: tUpdateJournalEntryParams.entryData,
      ),
      expect: () => [
        const JournalLoading(),
        JournalError(message: tUpdateEntryFailure.message),
      ],
      verify: (cubit) {
        verify(
          () => updateJournalEntry(tUpdateJournalEntryParams),
        ).called(1);
        verifyNoMoreInteractions(updateJournalEntry);
      },
    );
  });

  group('GetJournalEntries - ', () {
    final testEntries = <JournalEntry>[];
    final testGetEntriesFailure = GetEntriesFailure(
      message: 'message',
      statusCode: 500,
    );

    blocTest<JournalCubit, JournalState>(
      'given JournalCubit '
      'when [GetJournalEntries] is called '
      'then emit [JournalLoading, EntriesFetched] ',
      build: () {
        when(() => getJournalEntries(any())).thenAnswer(
          (_) => Stream.value(Right(testEntries)),
        );
        return cubit;
      },
      act: (cubit) => cubit.getEntries(
        userId: tGetJournalEntriesParams.userId,
      ),
      expect: () => [
        const JournalLoading(),
        EntriesFetched(
          entries: testEntries,
          hasReachedEnd: true,
        ),
      ],
      verify: (cubit) {
        verify(
          () => getJournalEntries(tGetJournalEntriesParams),
        ).called(1);
        verifyNoMoreInteractions(getJournalEntries);
      },
    );

    blocTest<JournalCubit, JournalState>(
      'given JournalCubit '
      'when [GetJournalEntries] call is unsuccessful '
      'then emit [JournalLoading, JournalError] ',
      build: () {
        when(() => getJournalEntries(any())).thenAnswer(
          (_) => Stream.value(Left(testGetEntriesFailure)),
        );
        return cubit;
      },
      act: (cubit) => cubit.getEntries(
        userId: tGetJournalEntriesParams.userId,
      ),
      expect: () => [
        const JournalLoading(),
        JournalError(
          message: testGetEntriesFailure.message,
        ),
      ],
      verify: (cubit) {
        verify(
          () => getJournalEntries(tGetJournalEntriesParams),
        ).called(1);
        verifyNoMoreInteractions(getJournalEntries);
      },
    );
  });
}
