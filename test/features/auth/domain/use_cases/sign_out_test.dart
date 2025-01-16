import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mental_health_journal_app/core/errors/failures.dart';
import 'package:mental_health_journal_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:mental_health_journal_app/features/auth/domain/use_cases/sign_out.dart';
import 'package:mocktail/mocktail.dart';

import 'auth_repository.mock.dart';

void main() {
  late AuthRepository repository;
  late SignOut useCase;
  final testFailure = SignOutFailure(
    message: 'message',
    statusCode: 500,
  );

  setUp(() {
    repository = MockAuthRepository();
    useCase = SignOut(repository);
  });

  test(
    'given SignOut '
    'when instantiated '
    'then call [AuthRepository.signOut] '
    'and return [void]',
    () async {
      // Arrange
      when(
        () => repository.signOut(),
      ).thenAnswer((_) async => const Right(null));

      // Act
      final result = await useCase();

      // Assert
      expect(result, const Right<Failure, void>(null));
      verify(() => repository.signOut()).called(1);
      verifyNoMoreInteractions(repository);
    },
  );

  test(
    'given SignOut '
    'when instantiated '
    'and call [AuthRepository.signOut] is unsuccessful '
    'then return [SignOutFailure]',
    () async {
      // Arrange
      when(
        () => repository.signOut(),
      ).thenAnswer((_) async => Left(testFailure));

      // Act
      final result = await useCase();

      // Assert
      expect(result, Left<Failure, void>(testFailure));
      verify(() => repository.signOut()).called(1);
      verifyNoMoreInteractions(repository);
    },
  );
}
