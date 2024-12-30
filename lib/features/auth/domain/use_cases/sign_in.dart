import 'package:equatable/equatable.dart';
import 'package:mental_health_journal_app/core/use_case.dart';
import 'package:mental_health_journal_app/core/utils/typedefs.dart';
import 'package:mental_health_journal_app/features/auth/domain/entities/user.dart';
import 'package:mental_health_journal_app/features/auth/domain/repositories/auth_repository.dart';

class SignIn implements UseCaseWithParams<UserEntity, SignInParams> {
  SignIn(this.repository);
  AuthRepository repository;
  @override
  ResultFuture<UserEntity> call(SignInParams params) => repository.signIn(
        email: params.email,
        password: params.password,
      );
}

class SignInParams extends Equatable {
  const SignInParams({
    required this.email,
    required this.password,
  });

  final String email;
  final String password;

  const SignInParams.empty()
      : this(
          email: '_empty.email',
          password: '_empty.password',
        );

  @override
  List<Object?> get props => [email, password];
}
