import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mental_health_journal_app/core/errors/failures.dart';
import 'package:mental_health_journal_app/features/journal/domain/entities/journal_entry.dart';
import 'package:mental_health_journal_app/features/journal/domain/repositories/journal_repository.dart';
import 'package:mental_health_journal_app/features/journal/domain/use_cases/delete_journal_entry.dart';
import 'package:mocktail/mocktail.dart';

import 'journal_repository.mock.dart';

void main() {
  late JournalRepository repository;
  late DeleteJournalEntry useCase;
  final testEntry = JournalEntry.empty();

  final testFailure = DeleteEntryFailure(message: 'message', statusCode: 500);

  setUp(() {
    repository = MockJournalRepository();
    useCase = DeleteJournalEntry(repository);
  });

  test(
    'given DeleteJournalEntry '
    'when instantiated '
    'then call [AuthRepository.deleteEntry] '
    'and return [void]',
    () async {
      // Arrange
      when(
        () => repository.deleteEntry(
          id: any(named: 'id'),
        ),
      ).thenAnswer((_) async => const Right(null));

      // Act
      final result = await useCase(testEntry.id);

      // Assert
      expect(result, const Right<Failure, void>(null));
      verify(
        () => repository.deleteEntry(
          id: testEntry.id,
        ),
      ).called(1);
      verifyNoMoreInteractions(repository);
    },
  );

  test(
    'given DeleteJournalEntry '
    'when instantiated '
    'and call [AuthRepository.deleteEntry] is unsuccessful '
    'then return [DeleteEntryFailure]',
    () async {
      // Arrange
      when(
        () => repository.deleteEntry(
          id: any(named: 'id'),
        ),
      ).thenAnswer((_) async => Left(testFailure));

      // Act
      final result = await useCase(testEntry.id);

      // Assert
      expect(result, Left<Failure, void>(testFailure));
      verify(
        () => repository.deleteEntry(
          id: testEntry.id,
        ),
      ).called(1);
      verifyNoMoreInteractions(repository);
    },
  );
}
