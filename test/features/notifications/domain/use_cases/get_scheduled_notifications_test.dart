import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mental_health_journal_app/core/errors/failures.dart';
import 'package:mental_health_journal_app/features/notifications/domain/entities/notification_entity.dart';
import 'package:mental_health_journal_app/features/notifications/domain/repositories/notification_repository.dart';
import 'package:mental_health_journal_app/features/notifications/domain/use_cases/get_scheduled_notifications.dart';
import 'package:mocktail/mocktail.dart';

import 'notification_repository.mock.dart';

void main() {
  late NotificationRepository repository;
  late GetScheduledNotifications useCase;

  final testResponse = [NotificationEntity.empty()];
  final testFailure = GetScheduledNotificationsFailure(
    message: 'message',
    statusCode: 500,
  );
  setUp(() {
    repository = MockNotificationRepository();
    useCase = GetScheduledNotifications(repository);
    registerFallbackValue(testResponse);
  });

  test(
    'given GetScheduledNotification '
    'when instantiated '
    'then call [NotificationRepository.etScheduledNotification] '
    'and return [void]',
    () async {
      // Arrange
      when(
        () => repository.getScheduledNotifications(),
      ).thenAnswer((_) async => Right(testResponse));

      // Act
      final result = await useCase();

      // Assert
      expect(result, Right<Failure, List<NotificationEntity>>(testResponse));
      verify(
        () => repository.getScheduledNotifications(),
      ).called(1);
      verifyNoMoreInteractions(repository);
    },
  );

  test(
    'given GetScheduledNotification '
    'when instantiated '
    'and call [NotificationRepository.etScheduledNotification] '
    'and return [GetScheduledNotificationFailure]',
    () async {
      // Arrange
      when(
        () => repository.getScheduledNotifications(),
      ).thenAnswer((_) async => Left(testFailure));

      // Act
      final result = await useCase();

      // Assert
      expect(result, Left<Failure, List<NotificationEntity>>(testFailure));
      verify(
        () => repository.getScheduledNotifications(),
      ).called(1);
      verifyNoMoreInteractions(repository);
    },
  );
}
