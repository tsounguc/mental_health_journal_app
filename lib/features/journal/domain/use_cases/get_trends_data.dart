import 'package:equatable/equatable.dart';
import 'package:mental_health_journal_app/core/use_case.dart';
import 'package:mental_health_journal_app/core/utils/typedefs.dart';
import 'package:mental_health_journal_app/features/journal/domain/entities/journal_entry.dart';
import 'package:mental_health_journal_app/features/journal/domain/repositories/journal_repository.dart';

class GetTrendsData extends StreamUseCaseWithParams<List<JournalEntry>, GetTrendsDataParams> {
  GetTrendsData(this._repository);

  final JournalRepository _repository;

  @override
  ResultStream<List<JournalEntry>> call(
    GetTrendsDataParams params,
  ) =>
      _repository.getDashboardData(userId: params.userId, today: params.today);
}

class GetTrendsDataParams extends Equatable {
  const GetTrendsDataParams({
    required this.userId,
    required this.today,
  });

  GetTrendsDataParams.empty()
      : this(
          userId: '_empty.userId',
          today: DateTime.now(),
        );
  final String userId;
  final DateTime today;

  @override
  List<Object?> get props => [userId, today];
}
