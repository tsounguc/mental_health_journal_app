import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mental_health_journal_app/core/errors/failures.dart';
import 'package:mental_health_journal_app/features/auth/domain/entities/user.dart';
import 'package:mental_health_journal_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:mental_health_journal_app/features/auth/domain/use_cases/sign_in_with_email_and_password.dart';
import 'package:mocktail/mocktail.dart';
import 'auth_repository.mock.dart';

void main() {
  late AuthRepository repository;
  late SignIn useCase;
  final testUser = UserEntity.empty();
  final testFailure = SignInWithEmailAndPasswordFailure(
    message: 'message',
    statusCode: 500,
  );

  final testParams = SignInParams.empty();

  setUp(() {
    useCase = SignIn();
    repository = MockAuthRepository();
  });

  test(
    'given SignInWithEmailAndPassword '
    'when instantiated '
    'then call [AuthRepository.signInWithEmailAndPassword] '
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
    },
  );
}
