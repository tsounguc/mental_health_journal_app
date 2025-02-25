import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mental_health_journal_app/core/errors/failures.dart';
import 'package:mental_health_journal_app/features/notifications/domain/repositories/notification_repository.dart';
import 'package:mental_health_journal_app/features/notifications/domain/use_cases/cancel_notification.dart';
import 'package:mocktail/mocktail.dart';

import 'notification_repository.mock.dart';

void main() {
  late NotificationRepository repository;
  late CancelNotification useCase;
  final testFailure = CancelNotificationFailure(
    message: 'message',
    statusCode: 500,
  );

  const testId = 1;

  setUp(() {
    repository = MockNotificationRepository();
    useCase = CancelNotification(repository);
  });

  test(
    'given CancelNotification '
    'when instantiated '
    'then call [NotificationRepository.cancelNotification] '
    'and return [void]',
    () async {
      // Arrange
      when(
        () => repository.cancelNotification(any()),
      ).thenAnswer((_) async => const Right(null));

      // Act
      final result = await useCase(testId);

      // Assert
      expect(result, const Right<Failure, void>(null));
      verify(
        () => repository.cancelNotification(testId),
      ).called(1);
      verifyNoMoreInteractions(repository);
    },
  );

  test(
    'given CancelNotification '
    'when instantiated '
    'and call [NotificationRepository.cancelNotification] is unsuccessful '
    'and return [CancelNotificationFailure]',
    () async {
      // Arrange
      when(
        () => repository.cancelNotification(any()),
      ).thenAnswer((_) async => Left(testFailure));

      // Act
      final result = await useCase(testId);

      // Assert
      expect(result, Left<Failure, void>(testFailure));
      verify(
        () => repository.cancelNotification(testId),
      ).called(1);
      verifyNoMoreInteractions(repository);
    },
  );
}
