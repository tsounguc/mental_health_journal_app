import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mental_health_journal_app/core/enums/update_user_action.dart';
import 'package:mental_health_journal_app/core/errors/failures.dart';
import 'package:mental_health_journal_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:mental_health_journal_app/features/auth/domain/use_cases/update_user.dart';
import 'package:mocktail/mocktail.dart';

import 'auth_repository.mock.dart';

void main() {
  late AuthRepository repository;
  late UpdateUser useCase;
  const testParams = UpdateUserParams(
    action: UpdateUserAction.name,
    userData: 'John Doe',
  );
  final testFailure = UpdateUserFailure(
    message: 'message',
    statusCode: 500,
  );

  setUp(() {
    repository = MockAuthRepository();
    useCase = UpdateUser(repository);
    registerFallbackValue(UpdateUserAction.name);
  });

  test(
    'given UpdateUser '
    'when instantiated '
    'then call [AuthRepository.updateUser] '
    'and return [void]',
    () async {
      // Arrange
      when(
        () => repository.updateUser(
          action: any(named: 'action'),
          userData: any<dynamic>(named: 'userData'),
        ),
      ).thenAnswer((_) async => const Right(null));

      // Act
      final result = await useCase(testParams);

      // Assert
      expect(result, const Right<Failure, void>(null));

      verify(
        () => repository.updateUser(
          action: testParams.action,
          userData: testParams.userData,
        ),
      ).called(1);

      verifyNoMoreInteractions(repository);
    },
  );

  test(
    'given UpdateUser '
    'when instantiated '
    'and call [AuthRepository.updateUser] is unsuccessful '
    'then return [UpdateUserFailure]',
    () async {
      // Arrange
      when(
        () => repository.updateUser(
          action: any(named: 'action'),
          userData: any<dynamic>(named: 'userData'),
        ),
      ).thenAnswer((_) async => Left(testFailure));

      // Act
      final result = await useCase(testParams);

      // Assert
      expect(result, Left<Failure, void>(testFailure));

      verify(
        () => repository.updateUser(
          action: testParams.action,
          userData: testParams.userData,
        ),
      ).called(1);

      verifyNoMoreInteractions(repository);
    },
  );
}
