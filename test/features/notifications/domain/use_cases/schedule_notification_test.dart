import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mental_health_journal_app/core/errors/failures.dart';
import 'package:mental_health_journal_app/features/notifications/domain/entities/notification_entity.dart';
import 'package:mental_health_journal_app/features/notifications/domain/repositories/notification_repository.dart';
import 'package:mental_health_journal_app/features/notifications/domain/use_cases/schedule_notification.dart';
import 'package:mocktail/mocktail.dart';

import 'notification_repository.mock.dart';

void main() {
  late NotificationRepository repository;
  late ScheduleNotification useCase;
  final testFailure = ScheduleNotificationFailure(
    message: 'message',
    statusCode: 500,
  );

  final testNotification = NotificationEntity.empty();

  setUp(() {
    repository = MockNotificationRepository();
    useCase = ScheduleNotification(repository);
    registerFallbackValue(testNotification);
  });

  test(
    'given ScheduleNotification '
    'when instantiated '
    'then call [NotificationRepository.scheduleNotification] '
    'and return [void]',
    () async {
      // Arrange
      when(
        () => repository.scheduleNotification(any()),
      ).thenAnswer((_) async => const Right(null));

      // Act
      final result = await useCase(testNotification);

      // Assert
      expect(result, const Right<Failure, void>(null));
      verify(
        () => repository.scheduleNotification(testNotification),
      ).called(1);
      verifyNoMoreInteractions(repository);
    },
  );

  test(
    'given ScheduleNotification '
    'when instantiated '
    'and call [NotificationRepository.scheduleNotification] is unsuccessful '
    'and return [ScheduleNotificationFailure]',
    () async {
      // Arrange
      when(
        () => repository.scheduleNotification(any()),
      ).thenAnswer((_) async => Left(testFailure));
      // Act
      final result = await useCase(testNotification);

      // Assert
      expect(result, Left<Failure, void>(testFailure));
      verify(
        () => repository.scheduleNotification(testNotification),
      ).called(1);
      verifyNoMoreInteractions(repository);
    },
  );
}
