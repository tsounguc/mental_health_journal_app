import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mental_health_journal_app/core/errors/failures.dart';
import 'package:mental_health_journal_app/features/journal/domain/entities/journal_entry.dart';
import 'package:mental_health_journal_app/features/journal/domain/use_cases/create_journal_entry.dart';
import 'package:mental_health_journal_app/features/journal/domain/use_cases/delete_journal_entry.dart';
import 'package:mental_health_journal_app/features/journal/domain/use_cases/update_journal_entry.dart';
import 'package:mental_health_journal_app/features/journal/presentation/journal_bloc/journal_bloc.dart';
import 'package:mocktail/mocktail.dart';

class MockCreateJournalEntry extends Mock implements CreateJournalEntry {}

class MockDeleteJournalEntry extends Mock implements DeleteJournalEntry {}

class MockUpdateJournalEntry extends Mock implements UpdateJournalEntry {}

void main() {
  late CreateJournalEntry createJournalEntry;
  late DeleteJournalEntry deleteJournalEntry;
  late UpdateJournalEntry updateJournalEntry;

  late JournalBloc bloc;

  final testEntry = JournalEntry.empty();

  setUp(() {
    createJournalEntry = MockCreateJournalEntry();
    deleteJournalEntry = MockDeleteJournalEntry();
    updateJournalEntry = MockUpdateJournalEntry();

    bloc = JournalBloc(
      createJournalEntry: createJournalEntry,
      deleteJournalEntry: deleteJournalEntry,
      updateJournalEntry: updateJournalEntry,
    );
  });

  late UpdateJournalEntryParams tUpdateJournalEntryParams;

  setUpAll(() {
    tUpdateJournalEntryParams = const UpdateJournalEntryParams.empty();
    registerFallbackValue(tUpdateJournalEntryParams);
    registerFallbackValue(testEntry);
  });

  tearDown(() {
    bloc.close();
  });

  test(
    'given JournalBloc '
    'when bloc is instantiated '
    'then initial state should be [JournalInitial]',
    () async {
      // Arrange
      // Act
      // Assert
      expect(bloc.state, const JournalInitial());
    },
  );

  group('CreateJournalEntry - ', () {
    final tCreateEntryFailure = CreateEntryFailure(
      message: 'message',
      statusCode: 500,
    );
    blocTest<JournalBloc, JournalState>(
      'given JournalBloc '
      'when [CreateJournalEntry] is called '
      'then emit [JournalLoading, EntryCreated]',
      build: () {
        when(
          () => createJournalEntry(any()),
        ).thenAnswer((_) async => const Right(null));
        return bloc;
      },
      act: (bloc) => bloc.add(
        CreateEntryEvent(
          entry: testEntry,
        ),
      ),
      expect: () => [
        const JournalLoading(),
        const EntryCreated(),
      ],
      verify: (bloc) {
        verify(
          () => createJournalEntry(testEntry),
        ).called(1);
        verifyNoMoreInteractions(createJournalEntry);
      },
    );

    blocTest<JournalBloc, JournalState>(
      'given JournalBloc '
      'when [CreateJournalEntry] call is unsuccessful '
      'then emit [JournalLoading, JournalError]',
      build: () {
        when(
          () => createJournalEntry(any()),
        ).thenAnswer((_) async => Left(tCreateEntryFailure));
        return bloc;
      },
      act: (bloc) => bloc.add(
        CreateEntryEvent(
          entry: testEntry,
        ),
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
    blocTest<JournalBloc, JournalState>(
      'given JournalBloc '
      'when [DeleteJournalEntry] is called '
      'then emit [JournalLoading, EntryDeleted]',
      build: () {
        when(
          () => deleteJournalEntry(any()),
        ).thenAnswer((_) async => const Right(null));
        return bloc;
      },
      act: (bloc) => bloc.add(
        DeleteEntryEvent(
          entryId: testEntry.id,
        ),
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

    blocTest<JournalBloc, JournalState>(
      'given JournalBloc '
      'when [DeleteJournalEntry] call is unsuccessful '
      'then emit [JournalLoading, JournalError]',
      build: () {
        when(
          () => deleteJournalEntry(any()),
        ).thenAnswer((_) async => Left(tDeleteEntryFailure));
        return bloc;
      },
      act: (bloc) => bloc.add(
        DeleteEntryEvent(
          entryId: testEntry.id,
        ),
      ),
      expect: () => [
        const JournalLoading(),
        JournalError(message: tDeleteEntryFailure.message),
      ],
      verify: (bloc) {
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
    blocTest<JournalBloc, JournalState>(
      'given JournalBloc '
      'when [UpdateJournalEntry] is called '
      'then emit [JournalLoading, EntryUpdated]',
      build: () {
        when(
          () => updateJournalEntry(any()),
        ).thenAnswer((_) async => const Right(null));
        return bloc;
      },
      act: (bloc) => bloc.add(
        UpdateEntryEvent(
          entryId: tUpdateJournalEntryParams.entryId,
          action: tUpdateJournalEntryParams.action,
          entryData: tUpdateJournalEntryParams.entryData,
        ),
      ),
      expect: () => [
        const JournalLoading(),
        const EntryUpdated(),
      ],
      verify: (bloc) {
        verify(
          () => updateJournalEntry(tUpdateJournalEntryParams),
        ).called(1);
        verifyNoMoreInteractions(updateJournalEntry);
      },
    );

    blocTest<JournalBloc, JournalState>(
      'given JournalBloc '
      'when [UpdateJournalEntry] call is unsuccessful '
      'then emit [JournalLoading, JournalError]',
      build: () {
        when(
          () => updateJournalEntry(any()),
        ).thenAnswer((_) async => Left(tUpdateEntryFailure));
        return bloc;
      },
      act: (bloc) => bloc.add(
        UpdateEntryEvent(
          entryId: tUpdateJournalEntryParams.entryId,
          action: tUpdateJournalEntryParams.action,
          entryData: tUpdateJournalEntryParams.entryData,
        ),
      ),
      expect: () => [
        const JournalLoading(),
        JournalError(message: tUpdateEntryFailure.message),
      ],
      verify: (bloc) {
        verify(
          () => updateJournalEntry(tUpdateJournalEntryParams),
        ).called(1);
        verifyNoMoreInteractions(updateJournalEntry);
      },
    );
  });
}
