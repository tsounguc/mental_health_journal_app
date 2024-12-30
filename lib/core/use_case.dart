import 'package:mental_health_journal_app/core/utils/typedefs.dart';

abstract class UseCase<T> {
  const UseCase();

  ResultFuture<T> call();
}

abstract class UseCaseWithParams<T, Params> {
  const UseCaseWithParams();

  ResultFuture<T> call(Params params);
}
