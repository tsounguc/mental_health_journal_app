import 'package:mental_health_journal_app/core/use_case.dart';
import 'package:mental_health_journal_app/core/utils/typedefs.dart';
import 'package:mental_health_journal_app/features/auth/domain/repositories/auth_repository.dart';

class DeleteAccount implements UseCaseWithParams<void, String> {
  const DeleteAccount(this._repository);
  final AuthRepository _repository;

  @override
  ResultFuture<void> call(
    String params,
  ) =>
      _repository.deleteAccount(password: params);
}
