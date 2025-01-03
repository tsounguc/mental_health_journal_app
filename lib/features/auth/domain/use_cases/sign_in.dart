import 'package:equatable/equatable.dart';
import 'package:mental_health_journal_app/core/use_case.dart';
import 'package:mental_health_journal_app/core/utils/typedefs.dart';
import 'package:mental_health_journal_app/features/auth/domain/entities/user.dart';
import 'package:mental_health_journal_app/features/auth/domain/repositories/auth_repository.dart';

class SignIn implements UseCaseWithParams<UserEntity, SignInParams> {
  SignIn(this._repository);
  final AuthRepository _repository;
  @override
  ResultFuture<UserEntity> call(SignInParams params) => _repository.signIn(
        email: params.email,
        password: params.password,
      );
}

class SignInParams extends Equatable {
  const SignInParams({
    required this.email,
    required this.password,
  });

  const SignInParams.empty()
      : this(
          email: '_empty.email',
          password: '_empty.password',
        );
  final String email;
  final String password;

  @override
  List<Object?> get props => [email, password];
}
