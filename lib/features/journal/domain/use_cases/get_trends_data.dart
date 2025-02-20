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
      _repository.getDashboardData(userId: params.userId, range: params.range);
}

class GetTrendsDataParams extends Equatable {
  const GetTrendsDataParams({
    required this.userId,
    required this.range,
  });

  GetTrendsDataParams.empty()
      : this(
          userId: '_empty.userId',
          range: DateTime.now(),
        );
  final String userId;
  final DateTime range;

  @override
  List<Object?> get props => [userId, range];
}
