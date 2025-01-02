import 'package:dartz/dartz.dart';
import 'package:mental_health_journal_app/core/enums/update_user_action.dart';
import 'package:mental_health_journal_app/core/errors/exceptions.dart';
import 'package:mental_health_journal_app/core/errors/failures.dart';
import 'package:mental_health_journal_app/core/utils/typedefs.dart';
import 'package:mental_health_journal_app/features/auth/data/data_sources/auth_remote_data_source.dart';
import 'package:mental_health_journal_app/features/auth/domain/entities/user.dart';
import 'package:mental_health_journal_app/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  const AuthRepositoryImpl(this._remoteDataSource);

  final AuthRemoteDataSource _remoteDataSource;
  @override
  ResultFuture<UserEntity> createUserAccount({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final result = await _remoteDataSource.createUserAccount(
        name: name,
        email: email,
        password: password,
      );
      return Right(result);
    } on CreateUserAccountException catch (e) {
      return Left(
        CreateUserAccountFailure.fromException(
          e,
        ),
      );
    }
  }

  @override
  ResultVoid deleteAccount({required String password}) async {
    try {
      final result = await _remoteDataSource.deleteAccount(
        password: password,
      );
      return Right(result);
    } on DeleteAccountException catch (e) {
      return Left(
        DeleteAccountFailure.fromException(
          e,
        ),
      );
    }
  }

  @override
  ResultVoid forgotPassword({
    required String email,
  }) async {
    try {
      final result = await _remoteDataSource.forgotPassword(
        email: email,
      );
      return Right(result);
    } on ForgotPasswordException catch (e) {
      return Left(
        ForgotPasswordFailure.fromException(
          e,
        ),
      );
    }
  }

  @override
  ResultFuture<UserEntity> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final result = await _remoteDataSource.signIn(
        email: email,
        password: password,
      );

      return Right(result);
    } on SignInException catch (e) {
      return Left(
        SignInFailure.fromException(
          e,
        ),
      );
    }
  }

  @override
  ResultVoid updateUser({
    required UpdateUserAction action,
    required userData,
  }) async {
    try {
      final result = await _remoteDataSource.updateUser(
        action: action,
        userData: userData,
      );
      return Right(result);
    } on UpdateUserException catch (e) {
      return Left(
        UpdateUserFailure.fromException(e),
      );
    }
  }
}
