import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mental_health_journal_app/core/enums/update_user_action.dart';
import 'package:mental_health_journal_app/core/errors/exceptions.dart';
import 'package:mental_health_journal_app/core/errors/failures.dart';
import 'package:mental_health_journal_app/features/auth/data/data_sources/auth_remote_data_source.dart';
import 'package:mental_health_journal_app/features/auth/data/models/user_model.dart';
import 'package:mental_health_journal_app/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:mental_health_journal_app/features/auth/domain/entities/user.dart';
import 'package:mental_health_journal_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRemoteDataSource extends Mock implements AuthRemoteDataSource {}

void main() {
  late AuthRemoteDataSource remoteDataSource;
  late AuthRepositoryImpl repositoryImpl;

  final testUserModel = UserModel.empty();
  const testPassword = '12345678';
  setUp(() {
    remoteDataSource = MockAuthRemoteDataSource();
    repositoryImpl = AuthRepositoryImpl(remoteDataSource);
    registerFallbackValue(UpdateUserAction.email);
  });

  test(
    'given AuthRepositoryImpl '
    'when instantiated '
    'then instance should be a subclass of [AuthRepositoryImpl]',
    () async {
      // Arrange
      // Act
      // Assert
      expect(repositoryImpl, isA<AuthRepository>());
    },
  );

  group('createUserAccount - ', () {
    test(
      'given AuthRepositoryImpl, '
      'when [AuthRemoteDataSource.createUserAccount] is called '
      'then return [UserEntity] ',
      () async {
        // Arrange
        when(
          () => remoteDataSource.createUserAccount(
            name: any(named: 'name'),
            email: any(named: 'email'),
            password: any(named: 'password'),
          ),
        ).thenAnswer((_) async => testUserModel);

        // Act
        final result = await repositoryImpl.createUserAccount(
          name: testUserModel.name,
          email: testUserModel.email,
          password: testPassword,
        );

        // Assert
        expect(
          result,
          Right<Failure, UserEntity>(testUserModel),
        );

        verify(
          () => remoteDataSource.createUserAccount(
            name: testUserModel.name,
            email: testUserModel.email,
            password: testPassword,
          ),
        ).called(1);

        verifyNoMoreInteractions(remoteDataSource);
      },
    );
    test(
      'given AuthRepositoryImpl, '
      'when [AuthRemoteDataSource.createUserAccount] call is unsuccessful '
      'then return [CreateUserAccountFailure] ',
      () async {
        // Arrange
        const testCreateUserAccountException = CreateUserAccountException(
          message: 'message',
          statusCode: '500',
        );
        when(
          () => remoteDataSource.createUserAccount(
            name: any(named: 'name'),
            email: any(named: 'email'),
            password: any(named: 'password'),
          ),
        ).thenThrow(testCreateUserAccountException);
        // Act
        final result = await repositoryImpl.createUserAccount(
          name: testUserModel.name,
          email: testUserModel.email,
          password: testPassword,
        );
        // Assert
        expect(
          result,
          Left<Failure, UserEntity>(
            CreateUserAccountFailure.fromException(
              testCreateUserAccountException,
            ),
          ),
        );

        // Assert
        verify(
          () => remoteDataSource.createUserAccount(
            name: testUserModel.name,
            email: testUserModel.email,
            password: testPassword,
          ),
        ).called(1);

        verifyNoMoreInteractions(remoteDataSource);
      },
    );
  });

  group('deleteAccount - ', () {
    test(
      'given AuthRepositoryImpl, '
      'when [AuthRemoteDataSource.deleteAccount] is called '
      'then return [void]',
      () async {
        // Arrange
        when(
          () => remoteDataSource.deleteAccount(
            email: any(named: 'email'),
          ),
        ).thenAnswer((_) async => Future.value());

        // Act
        final result = await repositoryImpl.deleteAccount(
          email: testUserModel.email,
        );

        // Assert
        expect(
          result,
          const Right<Failure, void>(null),
        );

        verify(
          () => remoteDataSource.deleteAccount(
            email: testUserModel.email,
          ),
        ).called(1);
        verifyNoMoreInteractions(remoteDataSource);
      },
    );

    test(
      'given AuthRepositoryImpl, '
      'when [AuthRemoteDataSource.delete] call is unsuccessful '
      'then return [DeleteAccountFailure] ',
      () async {
        // Arrange
        const testDeleteAccountException = DeleteAccountException(
          message: 'message',
          statusCode: '500',
        );
        when(
          () => remoteDataSource.deleteAccount(
            email: any(named: 'email'),
          ),
        ).thenThrow(testDeleteAccountException);

        // Act
        final result = await repositoryImpl.deleteAccount(
          email: testUserModel.email,
        );

        // Assert
        expect(
          result,
          Left<Failure, void>(
            DeleteAccountFailure.fromException(
              testDeleteAccountException,
            ),
          ),
        );
        verify(
          () => remoteDataSource.deleteAccount(
            email: testUserModel.email,
          ),
        ).called(1);
        verifyNoMoreInteractions(remoteDataSource);
      },
    );
  });

  group('forgotPassword - ', () {
    test(
      'given AuthRepositoryImpl, '
      'when [AuthRemoteDataSource.forgotPassword] is called '
      'then return [void]',
      () async {
        // Arrange
        when(
          () => remoteDataSource.forgotPassword(
            email: any(named: 'email'),
          ),
        ).thenAnswer((_) async => Future.value());

        // Act
        final result = await repositoryImpl.forgotPassword(
          email: testUserModel.email,
        );

        // Assert
        expect(
          result,
          const Right<Failure, void>(null),
        );
        verify(
          () => remoteDataSource.forgotPassword(
            email: testUserModel.email,
          ),
        ).called(1);
        verifyNoMoreInteractions(remoteDataSource);
      },
    );

    test(
      'given AuthRepositoryImpl, '
      'when [AuthRemoteDataSource.forgotPassword] call is unsuccessful '
      'then return [ForgotPasswordFailure] ',
      () async {
        // Arrange
        const testForgotPasswordException = ForgotPasswordException(
          message: 'message',
          statusCode: '500',
        );
        when(
          () => remoteDataSource.forgotPassword(
            email: any(named: 'email'),
          ),
        ).thenThrow(testForgotPasswordException);
        // Act
        final result = await repositoryImpl.forgotPassword(
          email: testUserModel.email,
        );

        // Assert
        expect(
          result,
          Left(
            ForgotPasswordFailure.fromException(
              testForgotPasswordException,
            ),
          ),
        );
        verify(
          () => remoteDataSource.forgotPassword(
            email: testUserModel.email,
          ),
        ).called(1);
        verifyNoMoreInteractions(remoteDataSource);
      },
    );
  });

  group('signIn - ', () {
    test(
      'given AuthRepositoryImpl, '
      'when [AuthRemoteDataSource.signIn] is called '
      'then return [UserEntity]',
      () async {
        // Arrange
        when(
          () => remoteDataSource.signIn(
            email: any(named: 'email'),
            password: any(named: 'password'),
          ),
        ).thenAnswer((_) async => testUserModel);

        // Act
        final result = await repositoryImpl.signIn(
          email: testUserModel.email,
          password: testPassword,
        );

        // Assert
        expect(
          result,
          Right<Failure, UserEntity>(testUserModel),
        );
        verify(
          () => remoteDataSource.signIn(
            email: testUserModel.email,
            password: testPassword,
          ),
        ).called(1);
        verifyNoMoreInteractions(remoteDataSource);
      },
    );

    test(
      'given AuthRepositoryImpl, '
      'when [AuthRemoteDataSource.signIn] called is unsuccessful'
      'then return [SignInFailure]',
      () async {
        // Arrange
        const testSignInException = SignInException(
          message: 'message',
          statusCode: '500',
        );
        when(
          () => remoteDataSource.signIn(
            email: any(named: 'email'),
            password: any(named: 'password'),
          ),
        ).thenThrow(testSignInException);

        // Act
        final result = await repositoryImpl.signIn(
          email: testUserModel.email,
          password: testPassword,
        );

        // Assert
        expect(
          result,
          Left<Failure, UserEntity>(
            SignInFailure.fromException(
              testSignInException,
            ),
          ),
        );
        verify(
          () => remoteDataSource.signIn(
            email: testUserModel.email,
            password: testPassword,
          ),
        ).called(1);
        verifyNoMoreInteractions(remoteDataSource);
      },
    );
  });

  group('updateUser - ', () {
    test(
      'given AuthRepositoryImpl, '
      'when [AuthRemoteDataSource.updateUser] is called'
      'then return [void]',
      () async {
        // Arrange
        const testUserData = 'newEmail@mail.com';
        const testAction = UpdateUserAction.email;
        when(
          () => remoteDataSource.updateUser(
            action: any(named: 'action'),
            userData: any<dynamic>(named: 'userData'),
          ),
        ).thenAnswer((_) async => Future.value());

        // Act
        final result = await repositoryImpl.updateUser(
          action: testAction,
          userData: testUserData,
        );

        // Assert
        expect(result, const Right<Failure, void>(null));
        verify(
          () => remoteDataSource.updateUser(
            action: testAction,
            userData: testUserData,
          ),
        ).called(1);
        verifyNoMoreInteractions(remoteDataSource);
      },
    );
    test(
      'given AuthRepositoryImpl, '
      'when [AuthRemoteDataSource.updateUser] called is unsuccessful'
      'then return [UpdateUserFailure]',
      () async {
        // Arrange
        const testUserData = 'newEmail@mail.com';
        const testAction = UpdateUserAction.email;
        const testUpdateUserException = UpdateUserException(
          message: 'message',
          statusCode: '500',
        );
        when(
          () => remoteDataSource.updateUser(
            action: any(named: 'action'),
            userData: any<dynamic>(named: 'userData'),
          ),
        ).thenThrow(testUpdateUserException);

        // Act
        final result = await repositoryImpl.updateUser(
          action: testAction,
          userData: testUserData,
        );

        // Assert
        expect(
          result,
          Left<Failure, void>(
            UpdateUserFailure.fromException(testUpdateUserException),
          ),
        );
        verify(
          () => remoteDataSource.updateUser(
            action: testAction,
            userData: testUserData,
          ),
        ).called(1);
        verifyNoMoreInteractions(remoteDataSource);
      },
    );
  });
}
