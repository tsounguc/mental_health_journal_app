import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mental_health_journal_app/core/errors/failures.dart';
import 'package:mental_health_journal_app/features/auth/domain/entities/user.dart';
import 'package:mental_health_journal_app/features/auth/domain/use_cases/create_user_account.dart';
import 'package:mental_health_journal_app/features/auth/domain/use_cases/delete_account.dart';
import 'package:mental_health_journal_app/features/auth/domain/use_cases/forgot_password.dart';
import 'package:mental_health_journal_app/features/auth/domain/use_cases/sign_in.dart';
import 'package:mental_health_journal_app/features/auth/domain/use_cases/update_user.dart';
import 'package:mental_health_journal_app/features/auth/presentation/auth_bloc/auth_bloc.dart';
import 'package:mocktail/mocktail.dart';

class MockCreateUserAccount extends Mock implements CreateUserAccount {}

class MockSignIn extends Mock implements SignIn {}

class MockDeleteAccount extends Mock implements DeleteAccount {}

class MockForgotPassword extends Mock implements ForgotPassword {}

class MockUpdateUser extends Mock implements UpdateUser {}

void main() {
  late CreateUserAccount createUserAccount;
  late SignIn signIn;
  late DeleteAccount deleteAccount;
  late ForgotPassword forgotPassword;
  late UpdateUser updateUser;

  late AuthBloc bloc;

  final testUser = UserEntity.empty();

  setUp(() {
    createUserAccount = MockCreateUserAccount();
    signIn = MockSignIn();
    deleteAccount = MockDeleteAccount();
    forgotPassword = MockForgotPassword();
    updateUser = MockUpdateUser();

    bloc = AuthBloc(
        createUserAccount: createUserAccount,
        signIn: signIn,
        deleteAccount: deleteAccount,
        forgotPassword: forgotPassword,
        updateUser: updateUser);
  });

  late CreateUserAccountParams tCreateUserAccountParams;
  late SignInParams tSignInParams;
  late UpdateUserParams tUpdateUserParams;

  setUpAll(() {
    tCreateUserAccountParams = const CreateUserAccountParams.empty();
    tSignInParams = const SignInParams.empty();
    tUpdateUserParams = const UpdateUserParams.empty();
    registerFallbackValue(tCreateUserAccountParams);
    registerFallbackValue(tSignInParams);
    registerFallbackValue(tUpdateUserParams);
  });

  tearDown(() {});

  test(
    'given AuthBloc '
    'when bloc is instantiated '
    'then initial state should be [AuthInitial] ',
    () async {
      // Arrange
      // Act
      // Assert
      expect(bloc.state, const AuthInitial());
    },
  );

  group('CreateUserAccount - ', () {
    final tCreateUserAccountFailure = CreateUserAccountFailure(
      message: 'message',
      statusCode: 500,
    );
    blocTest(
      'given AuthBloc '
      'when [CreateUserAccount] is called '
      'then emit [AuthLoading, SignedIn]',
      build: () {
        when(
          () => createUserAccount(any()),
        ).thenAnswer((_) async => Right(testUser));
        return bloc;
      },
      act: (bloc) => bloc.add(
        SignUpEvent(
          name: tCreateUserAccountParams.name,
          email: tCreateUserAccountParams.email,
          password: tCreateUserAccountParams.password,
        ),
      ),
      expect: () => [
        const AuthLoading(),
        SignedUp(user: testUser),
      ],
      verify: (bloc) {
        verify(
          () => createUserAccount(
            tCreateUserAccountParams,
          ),
        ).called(1);
        verifyNoMoreInteractions(createUserAccount);
      },
    );

    blocTest(
      'given AuthBloc '
      'when [CreateUserAccount] call is unsuccessful '
      'then emit [AuthLoading, AuthError]',
      build: () {
        when(
          () => createUserAccount(any()),
        ).thenAnswer((_) async => Left(tCreateUserAccountFailure));
        return bloc;
      },
      act: (bloc) => bloc.add(
        SignUpEvent(
          name: tCreateUserAccountParams.name,
          email: tCreateUserAccountParams.email,
          password: tCreateUserAccountParams.password,
        ),
      ),
      expect: () => [
        const AuthLoading(),
        AuthError(message: tCreateUserAccountFailure.message),
      ],
      verify: (bloc) {
        verify(
          () => createUserAccount(
            tCreateUserAccountParams,
          ),
        ).called(1);
        verifyNoMoreInteractions(createUserAccount);
      },
    );
  });

  group('SignIn - ', () {
    final tSignInFailure = SignInFailure(
      message: 'message',
      statusCode: 500,
    );
    blocTest<AuthBloc, AuthState>(
      'given AuthBloc'
      'when [SignIn] is called'
      'then emit [AuthLoading, SignedIn]',
      build: () {
        when(
          () => signIn(any()),
        ).thenAnswer((_) async => Right(testUser));
        return bloc;
      },
      act: (bloc) => bloc.add(
        SignInEvent(
          email: tSignInParams.email,
          password: tSignInParams.password,
        ),
      ),
      expect: () => [
        const AuthLoading(),
        SignedIn(user: testUser),
      ],
      verify: (bloc) {
        verify(() => signIn(tSignInParams)).called(1);
        verifyNoMoreInteractions(signIn);
      },
    );

    blocTest<AuthBloc, AuthState>(
      'given AuthBloc '
      'when [SignIn] call is unsuccessful '
      'then emit [AuthLoading, AuthError]',
      build: () {
        when(
          () => signIn(any()),
        ).thenAnswer((_) async => Left(tSignInFailure));
        return bloc;
      },
      act: (bloc) => bloc.add(
        SignInEvent(
          email: tSignInParams.email,
          password: tSignInParams.password,
        ),
      ),
      expect: () => [
        const AuthLoading(),
        AuthError(message: tSignInFailure.message),
      ],
      verify: (bloc) {
        verify(() => signIn(tSignInParams)).called(1);
        verifyNoMoreInteractions(signIn);
      },
    );
  });

  group('ForgotPassword - ', () {
    final tForgotPasswordFailure = ForgotPasswordFailure(
      message: 'message',
      statusCode: 500,
    );
    blocTest<AuthBloc, AuthState>(
      'given AuthBloc '
      'when [ForgotPassword] is called '
      'then emit [AuthLoading, ForgotPasswordSent]',
      build: () {
        when(
          () => forgotPassword(any()),
        ).thenAnswer((_) async => const Right(null));
        return bloc;
      },
      act: (bloc) => bloc.add(ForgotPasswordEvent(email: testUser.email)),
      expect: () => [const AuthLoading(), const ForgotPasswordSent()],
      verify: (bloc) {
        verify(
          () => forgotPassword(testUser.email),
        ).called(1);
        verifyNoMoreInteractions(forgotPassword);
      },
    );

    blocTest<AuthBloc, AuthState>(
      'given AuthBloc '
      'when [ForgotPassword] call is unsuccessful '
      'then emit [AuthLoading, AuthError] ',
      build: () {
        when(
          () => forgotPassword(any()),
        ).thenAnswer((_) async => Left(tForgotPasswordFailure));
        return bloc;
      },
      act: (bloc) => bloc.add(ForgotPasswordEvent(email: testUser.email)),
      expect: () => [
        const AuthLoading(),
        AuthError(message: tForgotPasswordFailure.message),
      ],
      verify: (bloc) {
        verify(() => forgotPassword(testUser.email)).called(1);
        verifyNoMoreInteractions(forgotPassword);
      },
    );
  });

  group('DeleteAccount - ', () {
    final tDeleteAccountFailure = DeleteAccountFailure(
      message: 'message',
      statusCode: 500,
    );
    const testPassword = '123456789';

    blocTest<AuthBloc, AuthState>(
      'given AuthBloc '
      'when [DeleteAccount] is called '
      'then emit [AuthLoading, AccountDeleted]',
      build: () {
        when(
          () => deleteAccount(any()),
        ).thenAnswer((_) async => const Right(null));
        return bloc;
      },
      act: (bloc) => bloc.add(const DeleteAccountEvent(password: testPassword)),
      expect: () => [const AuthLoading(), const AccountDeleted()],
      verify: (bloc) {
        verify(
          () => deleteAccount(testPassword),
        ).called(1);
        verifyNoMoreInteractions(deleteAccount);
      },
    );

    blocTest<AuthBloc, AuthState>(
      'given AuthBloc '
      'when [DeleteAccount] call is unsuccessful '
      'then emit [AuthLoading, AuthError] ',
      build: () {
        when(
          () => deleteAccount(any()),
        ).thenAnswer((_) async => Left(tDeleteAccountFailure));
        return bloc;
      },
      act: (bloc) => bloc.add(const DeleteAccountEvent(password: testPassword)),
      expect: () => [
        const AuthLoading(),
        AuthError(message: tDeleteAccountFailure.message),
      ],
      verify: (bloc) {
        verify(() => deleteAccount(testPassword)).called(1);
        verifyNoMoreInteractions(forgotPassword);
      },
    );
  });

  group('UpdateUser - ', () {
    final tUpdateUserFailure = UpdateUserFailure(
      message: 'message',
      statusCode: 500,
    );
    blocTest<AuthBloc, AuthState>(
      'given AuthBloc '
      'when [UpdateUser] is called '
      'then emit [AuthLoading, UserUpdated]',
      build: () {
        when(
          () => updateUser(any()),
        ).thenAnswer((_) async => const Right(null));
        return bloc;
      },
      act: (bloc) => bloc.add(
        UpdateUserEvent(
          action: tUpdateUserParams.action,
          userData: tUpdateUserParams.userData,
        ),
      ),
      expect: () => [
        const AuthLoading(),
        const UserUpdated(),
      ],
      verify: (bloc) {
        verify(
          () => updateUser(tUpdateUserParams),
        ).called(1);
        verifyNoMoreInteractions(updateUser);
      },
    );

    blocTest<AuthBloc, AuthState>(
      'given AuthBloc '
      'when [UpdateUser] call is unsuccessful '
      'then emit [AuthLoading, AuthError] ',
      build: () {
        when(
          () => updateUser(any()),
        ).thenAnswer((_) async => Left(tUpdateUserFailure));
        return bloc;
      },
      act: (bloc) => bloc.add(
        UpdateUserEvent(
          action: tUpdateUserParams.action,
          userData: tUpdateUserParams.userData,
        ),
      ),
      expect: () => [
        const AuthLoading(),
        AuthError(message: tUpdateUserFailure.message),
      ],
      verify: (bloc) {
        verify(() => updateUser(tUpdateUserParams)).called(1);
        verifyNoMoreInteractions(updateUser);
      },
    );
  });
}
