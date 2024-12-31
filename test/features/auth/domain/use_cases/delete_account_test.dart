import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mental_health_journal_app/core/errors/failures.dart';
import 'package:mental_health_journal_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:mental_health_journal_app/features/auth/domain/use_cases/delete_account.dart';
import 'package:mocktail/mocktail.dart';

import 'auth_repository.mock.dart';

void main() {
  late AuthRepository repository;
  late DeleteAccount useCase;
  const testEmail = 'testEmail@mail.com';
  final testFailure = DeleteAccountFailure(
    message: 'message',
    statusCode: 500,
  );

  setUp(() {
    repository = MockAuthRepository();
    useCase = DeleteAccount(repository);
  });

  test(
    'given DeleteAccount '
    'when instantiated '
    'then call [AuthRepository.deleteAccount] '
    'and return [void]',
    () async {
      // Arrange
      when(
        () => repository.deleteAccount(
          email: any(named: 'email'),
        ),
      ).thenAnswer((_) async => const Right(null));
      // Act
      final result = await useCase(testEmail);
      // Assert
      expect(result, const Right<Failure, void>(null));
    },
  );

  test(
    'given DeleteAccount '
    'when instantiated '
    'and call [AuthRepository.deleteAccount] is unsuccessful '
    'then return [DeleteAccountFailure]',
    () async {
      // Arrange
      when(
        () => repository.deleteAccount(
          email: any(named: 'email'),
        ),
      ).thenAnswer((_) async => Left(testFailure));

      // Act
      final result = await useCase(testEmail);

      // Assert
      expect(result, Left<Failure, void>(testFailure));
      verify(() => repository.deleteAccount(email: testEmail)).called(1);
      verifyNoMoreInteractions(repository);
    },
  );
}
