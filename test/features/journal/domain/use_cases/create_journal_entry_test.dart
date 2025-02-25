import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mental_health_journal_app/core/errors/failures.dart';
import 'package:mental_health_journal_app/features/journal/domain/entities/journal_entry.dart';
import 'package:mental_health_journal_app/features/journal/domain/repositories/journal_repository.dart';
import 'package:mental_health_journal_app/features/journal/domain/use_cases/create_journal_entry.dart';
import 'package:mocktail/mocktail.dart';

import 'journal_repository.mock.dart';

void main() {
  late JournalRepository repository;
  late CreateJournalEntry useCase;
  final testFailure = CreateEntryFailure(message: 'message', statusCode: 500);

  final testEntry = JournalEntry.empty();

  setUp(() {
    repository = MockJournalRepository();
    useCase = CreateJournalEntry(repository);
    registerFallbackValue(testEntry);
  });

  test(
    'given CreateJournalEntry '
    'when instantiated '
    'then call [JournalRepository.createEntry] '
    'and return [void]',
    () async {
      // Arrange
      when(
        () => repository.createEntry(entry: any(named: 'entry')),
      ).thenAnswer((_) async => const Right(null));

      // Act
      final result = await useCase(testEntry);
      // Assert
      expect(result, const Right<Failure, void>(null));
      verify(
        () => repository.createEntry(entry: testEntry),
      ).called(1);
      verifyNoMoreInteractions(repository);
    },
  );

  test(
    'given CreateJournalEntry '
    'when instantiated '
    'and call [JournalRepository.createEntry] is unsuccessful '
    'then return [CreateEntryFailure]',
    () async {
      // Arrange
      when(
        () => repository.createEntry(entry: any(named: 'entry')),
      ).thenAnswer((_) async => Left(testFailure));

      // Act
      final result = await useCase(testEntry);

      // Assert
      expect(result, Left<Failure, void>(testFailure));
      verify(
        () => repository.createEntry(
          entry: testEntry,
        ),
      ).called(1);
      verifyNoMoreInteractions(repository);
    },
  );
}
