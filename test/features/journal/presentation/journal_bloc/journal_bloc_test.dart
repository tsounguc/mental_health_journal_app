import 'package:flutter_test/flutter_test.dart';
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
}
