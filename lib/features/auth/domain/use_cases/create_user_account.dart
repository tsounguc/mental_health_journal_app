import 'package:equatable/equatable.dart';
import 'package:mental_health_journal_app/core/use_case.dart';
import 'package:mental_health_journal_app/core/utils/typedefs.dart';
import 'package:mental_health_journal_app/features/auth/domain/entities/user.dart';
import 'package:mental_health_journal_app/features/auth/domain/repositories/auth_repository.dart';

class CreateUserAccount implements UseCaseWithParams<UserEntity, CreateUserAccountParams> {
  const CreateUserAccount(this.repository);

  final AuthRepository repository;
  @override
  ResultFuture<UserEntity> call(CreateUserAccountParams params) => repository.createUserAccount(
        name: params.name,
        email: params.email,
        password: params.password,
      );
}

class CreateUserAccountParams extends Equatable {
  const CreateUserAccountParams({
    required this.name,
    required this.email,
    required this.password,
  });

  const CreateUserAccountParams.empty()
      : this(
          name: '_empty.name',
          email: '_empty.email',
          password: '_empty.password',
        );

  final String name;
  final String email;
  final String password;
  @override
  List<Object?> get props => [name, email, password];
}
