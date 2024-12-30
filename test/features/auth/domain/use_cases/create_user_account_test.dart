import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mental_health_journal_app/core/errors/failures.dart';
import 'package:mental_health_journal_app/features/auth/domain/entities/user.dart';
import 'package:mental_health_journal_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:mental_health_journal_app/features/auth/domain/use_cases/create_user_account.dart';
import 'package:mocktail/mocktail.dart';

import 'auth_repository.mock.dart';

void main() {
  late AuthRepository repository;
  late CreateUserAccount useCase;
  final testUser = UserEntity.empty();
  final testFailure = CreateUserAccountFailure(
    message: 'message',
    statusCode: 500,
  );

  const testParams = CreateUserAccountParams.empty();

  setUp(() {
    repository = MockAuthRepository();
    useCase = CreateUserAccount(repository);
  });

  test(
    'given CreateUserAccount '
    'when instantiated '
    'then call [AuthRepository.createUserAccount] '
    'and return [UserEntity]',
    () async {
      // Arrange
      when(
        () => repository.createUserAccount(
          name: any(named: 'name'),
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      ).thenAnswer((_) async => Right(testUser));
      // Act
      final result = await useCase(testParams);

      // Assert
      expect(result, Right<Failure, UserEntity>(testUser));
      verify(
        () => repository.createUserAccount(
          name: testParams.name,
          email: testParams.email,
          password: testParams.password,
        ),
      ).called(1);
      verifyNoMoreInteractions(repository);
    },
  );

  test(
    'given CreateUserAccount '
    'when instantiated '
    'and call [AuthRepository.createUserAccount] '
    'then return [CreateUserFailure]',
    () async {
      // Arrange
      when(
        () => repository.createUserAccount(
          name: any(named: 'name'),
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      ).thenAnswer((_) async => Left(testFailure));

      // Act
      final result = await useCase(testParams);

      // Assert
      expect(
        result,
        Left<Failure, UserEntity>(testFailure),
      );
      verify(
        () => repository.createUserAccount(
          name: testParams.name,
          email: testParams.email,
          password: testParams.password,
        ),
      ).called(1);
      verifyNoMoreInteractions(repository);
    },
  );
}
