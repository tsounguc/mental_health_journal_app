import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mental_health_journal_app/core/errors/failures.dart';
import 'package:mental_health_journal_app/features/auth/domain/entities/user.dart';
import 'package:mental_health_journal_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:mental_health_journal_app/features/auth/domain/use_cases/forgot_password.dart';
import 'package:mocktail/mocktail.dart';

import 'auth_repository.mock.dart';

void main() {
  late AuthRepository repository;
  late ForgotPassword useCase;
  final testUser = UserEntity.empty();
  final testFailure = ForgotPasswordFailure(message: 'message', statusCode: 500);
  const testEmail = 'testEmail@mail.com';
  setUp(() {
    repository = MockAuthRepository();
    useCase = ForgotPassword(repository);
  });

  test(
    'given ForgotPassword '
    'when instantiated '
    'then call [AuthRepository.forgotPassword] '
    'and return [void]',
    () async {
      // Arrange
      when(
        () => repository.forgotPassword(
          email: any(named: 'email'),
        ),
      ).thenAnswer((_) async => const Right(null));

      // Act
      final result = await useCase(testEmail);

      // Assert
      expect(result, const Right<Failure, void>(null));
      verify(() => repository.forgotPassword(email: testEmail)).called(1);
      verifyNoMoreInteractions(repository);
    },
  );

  test(
    'given ForgotPassword '
    'when instantiated '
    'and call [AuthRepository.forgotPassword] is unsuccessful '
    'then return [ForgotPasswordFailure]',
    () async {
      // Arrange
      when(
        () => repository.forgotPassword(
          email: any(named: 'email'),
        ),
      ).thenAnswer((_) async => Left(testFailure));

      // Act
      final result = await useCase(testEmail);

      // Assert
      expect(result, Left<Failure, void>(testFailure));
      verify(() => repository.forgotPassword(email: testEmail)).called(1);
      verifyNoMoreInteractions(repository);
    },
  );
}
