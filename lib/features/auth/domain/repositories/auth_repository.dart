import 'package:mental_health_journal_app/core/enums/update_user_action.dart';
import 'package:mental_health_journal_app/core/utils/typedefs.dart';
import 'package:mental_health_journal_app/features/auth/domain/entities/user.dart';

abstract class AuthRepository {
  const AuthRepository();

  ResultFuture<UserEntity> createUserAccount({
    required String name,
    required String email,
    required String password,
  });

  ResultFuture<UserEntity> signIn({
    required String email,
    required String password,
  });

  ResultVoid forgotPassword({
    required String email,
  });

  ResultVoid updateUser({
    required UpdateUserAction action,
    required dynamic userData,
  });

  ResultVoid deleteAccount({
    required String password,
  });
}
