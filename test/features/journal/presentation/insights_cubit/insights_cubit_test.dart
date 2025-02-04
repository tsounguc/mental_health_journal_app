import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mental_health_journal_app/core/errors/failures.dart';
import 'package:mental_health_journal_app/features/journal/domain/entities/journal_entry.dart';
import 'package:mental_health_journal_app/features/journal/domain/use_cases/get_trends_data.dart';
import 'package:mental_health_journal_app/features/journal/presentation/insights_cubit/insights_cubit.dart';
import 'package:mocktail/mocktail.dart';

class MockGetTrendsData extends Mock implements GetTrendsData {}

void main() {
  late GetTrendsData getTrendsData;

  late InsightsCubit cubit;

  setUp(() {
    getTrendsData = MockGetTrendsData();

    cubit = InsightsCubit(getTrendsData: getTrendsData);
  });

  late GetTrendsDataParams tGetTrendsDataParams;

  setUpAll(() {
    tGetTrendsDataParams = GetTrendsDataParams.empty();
    registerFallbackValue(tGetTrendsDataParams);
  });

  tearDown(() {
    cubit.close();
  });

  test(
    'given InsightsCubit '
    'when cubit is instantiated '
    'then initial state should be [InsightsInitial]',
    () async {
      // Arrange
      // Act
      // Assert
      expect(cubit.state, InsightsInitial());
    },
  );

  group('GetTrendsData - ', () {
    final testEntries = <JournalEntry>[];
    final tGetDashboardDataFailure = GetDashboardDataFailure(
      message: 'message',
      statusCode: 'statusCode',
    );

    blocTest<InsightsCubit, InsightsState>(
      'given InsightsCubit '
      'when [GetTrendsData] is called '
      'then emit [DashboardLoading, DashboardDataFetched]',
      build: () {
        when(() => getTrendsData(any())).thenAnswer(
          (_) => Stream.value(Right(testEntries)),
        );
        return cubit;
      },
      act: (cubit) => cubit.getDashboardData(
        userId: tGetTrendsDataParams.userId,
      ),
      expect: () => [
        const DashboardLoading(),
        DashboardDataFetched(entries: testEntries),
      ],
      verify: (cubit) {
        verify(
          () => getTrendsData(any()),
        ).called(1);
        verifyNoMoreInteractions(getTrendsData);
      },
    );

    blocTest<InsightsCubit, InsightsState>(
      'given InsightsCubit '
      'when [GetTrendsData] call is unsuccessful '
      'then emit [DashboardLoading(), InsightsError()]',
      build: () {
        when(() => getTrendsData(any())).thenAnswer(
          (_) => Stream.value(Left(tGetDashboardDataFailure)),
        );
        return cubit;
      },
      act: (cubit) => cubit.getDashboardData(
        userId: tGetTrendsDataParams.userId,
      ),
      expect: () => [
        const DashboardLoading(),
        InsightsError(message: tGetDashboardDataFailure.message),
      ],
      verify: (cubit) {
        verify(
          () => getTrendsData(any()),
        ).called(1);
        verifyNoMoreInteractions(getTrendsData);
      },
    );
  });
}
