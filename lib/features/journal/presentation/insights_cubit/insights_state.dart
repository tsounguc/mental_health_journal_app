part of 'insights_cubit.dart';

sealed class InsightsState extends Equatable {
  const InsightsState();

  @override
  List<Object> get props => [];
}

final class InsightsInitial extends InsightsState {}

final class DashboardLoading extends InsightsState {
  const DashboardLoading();
}

final class InsightsError extends InsightsState {
  const InsightsError({
    required this.message,
  });

  final String message;

  @override
  List<Object> get props => [message];
}

final class DashboardDataFetched extends InsightsState {
  const DashboardDataFetched({
    required this.entries,
  });

  final List<JournalEntry> entries;

  @override
  List<Object> get props => [
        entries,
      ];
}
