import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mental_health_journal_app/core/errors/failures.dart';
import 'package:mental_health_journal_app/features/journal/domain/entities/journal_entry.dart';
import 'package:mental_health_journal_app/features/journal/domain/repositories/journal_repository.dart';
import 'package:mental_health_journal_app/features/journal/domain/use_cases/get_trends_data.dart';
import 'package:mocktail/mocktail.dart';

import 'journal_repository.mock.dart';

void main() {
  late JournalRepository repository;
  late GetTrendsData useCase;

  final testResponse = [JournalEntry.empty()];
  final testParams = GetTrendsDataParams.empty();

  final testGetDashboardFailure = GetDashboardDataFailure(
    message: 'message',
    statusCode: 'statusCode',
  );

  setUp(() {
    repository = MockJournalRepository();
    useCase = GetTrendsData(repository);
    registerFallbackValue(testResponse);
  });

  test(
    'given GetTrendsDashboardData '
    'when instantiated '
    'then call [JournalRepository.getDashboardData] '
    'and return [List<JournalEntry>]',
    () async {
      // Arrange
      when(
        () => repository.getDashboardData(
          userId: any(named: 'userId'),
          today: any(named: 'today'),
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
        () => repository.getDashboardData(
          userId: testParams.userId,
          today: testParams.today,
        ),
      ).called(1);
      verifyNoMoreInteractions(repository);
    },
  );

  test(
    'given GetTrendsData '
    'when instantiated '
    'and call [JournalRepository.getDashboardData] is unsuccessful '
    'then return [GetDashboardDataFailure]',
    () async {
      // Arrange
      when(
        () => repository.getDashboardData(
          userId: any(named: 'userId'),
          today: any(named: 'today'),
        ),
      ).thenAnswer(
        (_) => Stream.value(
          Left(testGetDashboardFailure),
        ),
      );

      // Act
      final result = useCase(testParams);

      // Assert
      expect(
        result,
        emits(
          Left<Failure, List<JournalEntry>>(testGetDashboardFailure),
        ),
      );
      verify(
        () => repository.getDashboardData(
          userId: testParams.userId,
          today: testParams.today,
        ),
      ).called(1);
      verifyNoMoreInteractions(repository);
    },
  );
}
