import 'package:mental_health_journal_app/core/use_case.dart';
import 'package:mental_health_journal_app/core/utils/typedefs.dart';
import 'package:mental_health_journal_app/features/auth/domain/repositories/auth_repository.dart';

class ForgotPassword implements UseCaseWithParams<void, String> {
  const ForgotPassword(this._repository);

  final AuthRepository _repository;

  @override
  ResultVoid call(String params) => _repository.forgotPassword(
        email: params,
      );
}
