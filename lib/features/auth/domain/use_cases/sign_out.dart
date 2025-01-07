import 'package:mental_health_journal_app/core/use_case.dart';
import 'package:mental_health_journal_app/core/utils/typedefs.dart';
import 'package:mental_health_journal_app/features/auth/domain/repositories/auth_repository.dart';

class SignOut implements UseCase<void> {
  SignOut(this._repository);
  final AuthRepository _repository;
  @override
  ResultFuture<void> call() => _repository.signOut();
}
