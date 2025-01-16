import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mental_health_journal_app/core/errors/failures.dart';
import 'package:mental_health_journal_app/features/journal/domain/entities/journal_entry.dart';
import 'package:mental_health_journal_app/features/journal/domain/repositories/journal_repository.dart';
import 'package:mental_health_journal_app/features/journal/domain/use_cases/get_journal_entries.dart';
import 'package:mocktail/mocktail.dart';

import 'journal_repository.mock.dart';

void main() {
  late JournalRepository repository;
  late GetJournalEntries useCase;

  final testResponse = [JournalEntry.empty()];
  const testParams = GetJournalEntriesParams.empty();
  final testGetEntriesFailure = GetEntriesFailure(
    message: 'message',
    statusCode: 'statusCode',
  );
  setUp(() {
    repository = MockJournalRepository();
    useCase = GetJournalEntries(repository);
    registerFallbackValue(testResponse);
  });

  test(
    'given GetJournalEntries '
    'when instantiated '
    'then call [JournalRepository.getEntries] '
    'and return [List<JournalEntry>]',
    () async {
      // Arrange
      when(
        () => repository.getEntries(
          userId: any(named: 'userId'),
          startAfterId: any(named: 'startAfterId'),
          paginationSize: any(named: 'paginationSize'),
        ),
      ).thenAnswer((_) => Stream.value(Right(testResponse)));

      // Act
      final result = useCase(testParams);

      // Assert
      expect(
        result,
        emits(Right<Failure, List<JournalEntry>>(testResponse)),
      );
      verify(
        () => repository.getEntries(
          userId: testParams.userId,
          startAfterId: testParams.startAfterId,
          paginationSize: testParams.paginationSize,
        ),
      ).called(1);
      verifyNoMoreInteractions(repository);
    },
  );

  test(
    'given GetJournalEntries '
    'when instantiated '
    'and call [JournalRepository.getEntries] is unsuccessful '
    'then return [GetEntriesFailure]',
    () async {
      // Arrange
      when(
        () => repository.getEntries(
          userId: any(named: 'userId'),
          startAfterId: any(named: 'startAfterId'),
          paginationSize: any(named: 'paginationSize'),
        ),
      ).thenAnswer((_) => Stream.value(Left(testGetEntriesFailure)));

      // Act
      final result = useCase(testParams);

      // Assert
      expect(
        result,
        emits(Left<Failure, List<JournalEntry>>(testGetEntriesFailure)),
      );
      verify(
        () => repository.getEntries(
          userId: testParams.userId,
          startAfterId: testParams.startAfterId,
          paginationSize: testParams.paginationSize,
        ),
      ).called(1);
      verifyNoMoreInteractions(repository);
    },
  );
}
