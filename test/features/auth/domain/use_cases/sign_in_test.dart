import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mental_health_journal_app/core/errors/failures.dart';
import 'package:mental_health_journal_app/features/auth/domain/entities/user.dart';
import 'package:mental_health_journal_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:mental_health_journal_app/features/auth/domain/use_cases/sign_in.dart';
import 'package:mocktail/mocktail.dart';
import 'auth_repository.mock.dart';

void main() {
  late AuthRepository repository;
  late SignIn useCase;
  final testUser = UserEntity.empty();
  final testFailure = SignInFailure(
    message: 'message',
    statusCode: 500,
  );

  const testParams = SignInParams.empty();

  setUp(() {
    repository = MockAuthRepository();
    useCase = SignIn(repository);
  });

  test(
    'given SignIn '
    'when instantiated '
    'then call [AuthRepository.signIn] '
    'and return [UserEntity]',
    () async {
      // Arrange
      when(
        () => repository.signIn(
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      ).thenAnswer((_) async => Right(testUser));

      // Act
      final result = await useCase(testParams);

      // Assert
      expect(result, Right<Failure, UserEntity>(testUser));
      verify(
        () => repository.signIn(
          email: testParams.email,
          password: testParams.password,
        ),
      ).called(1);
      verifyNoMoreInteractions(repository);
    },
  );

  test(
    'given SignIn '
    'when instantiated '
    'and call [AuthRepository.signIn] is unsuccessful '
    'then return [SignInFailure]',
    () async {
      // Arrange
      when(
        () => repository.signIn(
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      ).thenAnswer((_) async => Left(testFailure));
      // Act
      final result = await useCase(testParams);
      // Assert
      expect(result, Left<Failure, UserEntity>(testFailure));
      verify(
        () => repository.signIn(
          email: testParams.email,
          password: testParams.password,
        ),
      ).called(1);
      verifyNoMoreInteractions(repository);
    },
  );
}
