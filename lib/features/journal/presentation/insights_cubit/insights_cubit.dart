import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:mental_health_journal_app/core/errors/failures.dart';
import 'package:mental_health_journal_app/features/journal/domain/entities/journal_entry.dart';
import 'package:mental_health_journal_app/features/journal/domain/use_cases/get_trends_dashboard_data.dart';

part 'insights_state.dart';

class InsightsCubit extends Cubit<InsightsState> {
  InsightsCubit({
    required GetTrendsDashboardData getTrendsDashboardData,
  })  : _getTrendsDashboardData = getTrendsDashboardData,
        super(InsightsInitial());

  final GetTrendsDashboardData _getTrendsDashboardData;

  StreamSubscription<Either<Failure, List<JournalEntry>>>? subscription;

  void getDashboardData({required String userId}) {
    emit(const DashboardLoading());
    subscription?.cancel();
    subscription = _getTrendsDashboardData(
      GetTrendsDashboardDataParams(
        userId: userId,
        today: DateTime.now(),
      ),
    ).listen(
      (result) {
        result.fold(
          (failure) {
            debugPrint(failure.message);
            emit(InsightsError(message: failure.message));
            subscription?.cancel();
          },
          (entries) async {
            emit(DashboardDataFetched(entries: entries));
          },
        );
      },
      onDone: () {
        subscription?.cancel();
      },
    );
  }

  @override
  Future<void> close() {
    subscription?.cancel();
    return super.close();
  }
}
