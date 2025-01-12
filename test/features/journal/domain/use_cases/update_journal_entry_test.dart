import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mental_health_journal_app/core/enums/update_entry_action.dart';
import 'package:mental_health_journal_app/core/errors/failures.dart';
import 'package:mental_health_journal_app/features/journal/domain/repositories/journal_repository.dart';
import 'package:mental_health_journal_app/features/journal/domain/use_cases/update_journal_entry.dart';
import 'package:mocktail/mocktail.dart';

import 'journal_repository.mock.dart';

void main() {
  late JournalRepository repository;
  late UpdateJournalEntry useCase;

  const testParams = UpdateJournalEntryParams.empty();
  final testFailure = UpdateEntryFailure(
    message: 'message',
    statusCode: 500,
  );

  setUp(() {
    repository = MockJournalRepository();
    useCase = UpdateJournalEntry(repository);
    registerFallbackValue(UpdateEntryAction.content);
  });

  test(
    'given UpdateJournalEntry '
    'when instantiated '
    'then call [AuthRepository.updateEntry] '
    'and return [void]',
    () async {
      // Arrange
      when(
        () => repository.updateEntry(
          entryId: any(named: 'entryId'),
          action: any(named: 'action'),
          entryData: any<dynamic>(named: 'entryData'),
        ),
      ).thenAnswer((_) async => const Right(null));

      // Act
      final result = await useCase(testParams);

      // Assert
      expect(result, const Right<Failure, void>(null));
      verify(
        () => repository.updateEntry(
          entryId: testParams.entryId,
          action: testParams.action,
          entryData: testParams.entryData,
        ),
      ).called(1);
      verifyNoMoreInteractions(repository);
    },
  );

  test(
    'given UpdateJournalEntry '
    'when instantiated '
    'and call [JournalRepository.updateEntry] is unsuccessful '
    'then return [UpdateEntryFailure]',
    () async {
      // Arrange
      when(
        () => repository.updateEntry(
          entryId: any(named: 'entryId'),
          action: any(named: 'action'),
          entryData: any<dynamic>(named: 'entryData'),
        ),
      ).thenAnswer((_) async => Left(testFailure));

      // Act
      final result = await useCase(testParams);

      // Assert
      expect(result, Left<Failure, void>(testFailure));
      verify(
        () => repository.updateEntry(
          entryId: testParams.entryId,
          action: testParams.action,
          entryData: testParams.entryData,
        ),
      ).called(1);
      verifyNoMoreInteractions(repository);
    },
  );
}
