import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mental_health_journal_app/core/errors/exceptions.dart';
import 'package:mental_health_journal_app/core/errors/failures.dart';
import 'package:mental_health_journal_app/features/notifications/data/data_sources/notification_local_data_source.dart';
import 'package:mental_health_journal_app/features/notifications/data/models/notification_model.dart';
import 'package:mental_health_journal_app/features/notifications/data/repositories/notification_repository_impl.dart';
import 'package:mental_health_journal_app/features/notifications/domain/entities/notification_entity.dart';
import 'package:mental_health_journal_app/features/notifications/domain/repositories/notification_repository.dart';
import 'package:mocktail/mocktail.dart';

class MockNotificationLocalDataSource extends Mock implements NotificationLocalDataSource {}

void main() {
  late NotificationLocalDataSource localDataSource;
  late NotificationRepositoryImpl repositoryImpl;

  final testNotification = NotificationEntity.empty();
  final testResponse = [NotificationModel.empty()];

  setUp(() {
    localDataSource = MockNotificationLocalDataSource();
    repositoryImpl = NotificationRepositoryImpl(localDataSource);
    registerFallbackValue(testNotification);
    registerFallbackValue(testResponse);
  });

  test(
    'given NotificationRepositoryImpl '
    'when instantiated '
    'then instance should be a subclass of [NotificationRepository]',
    () async {
      // Arrange
      // Act
      // Assert
      expect(repositoryImpl, isA<NotificationRepository>());
    },
  );

  group('scheduleNotification - ', () {
    test(
      'given NotificationRepositoryImpl, '
      'when [NotificationLocalDataSource.scheduleNotification] is called '
      'then return [void]',
      () async {
        // Arrange
        when(
          () => localDataSource.scheduleNotification(any()),
        ).thenAnswer((_) async => Future.value());

        // Act
        final result = await repositoryImpl.scheduleNotification(
          testNotification,
        );

        // Assert
        expect(
          result,
          const Right<Failure, void>(null),
        );

        verify(
          () => localDataSource.scheduleNotification(testNotification),
        ).called(1);

        verifyNoMoreInteractions(localDataSource);
      },
    );

    test(
      'given NotificationRepositoryImpl, '
      'when [NotificationLocalDataSource.scheduleNotification] call unsuccessful'
      ' then return [ScheduleNotificationFailure]',
      () async {
        // Arrange
        const testScheduleNotificationException = ScheduleNotificationException(
          message: 'message',
          statusCode: '500',
        );
        when(
          () => localDataSource.scheduleNotification(any()),
        ).thenThrow(testScheduleNotificationException);

        // Act
        final result = await repositoryImpl.scheduleNotification(testNotification);

        // Assert
        expect(
          result,
          Left<Failure, void>(
            ScheduleNotificationFailure.fromException(
              testScheduleNotificationException,
            ),
          ),
        );

        verify(
          () => localDataSource.scheduleNotification(testNotification),
        ).called(1);

        verifyNoMoreInteractions(localDataSource);
      },
    );
  });

  group('cancelNotification - ', () {
    test(
      'given NotificationRepositoryImpl, '
      'when [NotificationLocalDataSource.cancelNotification] is called '
      'then return [void]',
      () async {
        // Arrange
        when(
          () => localDataSource.cancelNotification(any()),
        ).thenAnswer((_) async => Future.value());

        // Act
        final result = await repositoryImpl.cancelNotification(
          testNotification.id,
        );

        // Assert
        expect(
          result,
          const Right<Failure, void>(null),
        );

        verify(
          () => localDataSource.cancelNotification(testNotification.id),
        ).called(1);

        verifyNoMoreInteractions(localDataSource);
      },
    );

    test(
      'given NotificationRepositoryImpl, '
      'when [NotificationLocalDataSource.cancelNotification] call unsuccessful'
      ' then return [CancelNotificationFailure]',
      () async {
        // Arrange
        const testCancelNotificationException = CancelNotificationException(
          message: 'message',
          statusCode: '500',
        );
        when(
          () => localDataSource.cancelNotification(any()),
        ).thenThrow(testCancelNotificationException);

        // Act
        final result = await repositoryImpl.cancelNotification(testNotification.id);

        // Assert
        expect(
          result,
          Left<Failure, void>(
            CancelNotificationFailure.fromException(
              testCancelNotificationException,
            ),
          ),
        );

        verify(
          () => localDataSource.cancelNotification(testNotification.id),
        ).called(1);

        verifyNoMoreInteractions(localDataSource);
      },
    );
  });

  group('getScheduledNotifications - ', () {
    test(
      'given NotificationRepositoryImpl, '
      'when [NotificationLocalDataSource.getScheduledNotifications] called '
      'then return a [List<Notification>]',
      () async {
        // Arrange
        when(
          () => localDataSource.getScheduledNotifications(),
        ).thenAnswer((_) async => testResponse);

        // Act
        final result = await repositoryImpl.getScheduledNotifications();

        // Assert
        expect(
          result,
          Right<Failure, List<NotificationEntity>>(testResponse),
        );
        verify(
          () => localDataSource.getScheduledNotifications(),
        ).called(1);
        verifyNoMoreInteractions(localDataSource);
      },
    );

    test(
      'given NotificationRepositoryImpl, '
      'when [NotificationLocalDataSource.getScheduledNotifications] call unsuccessful '
      'then return a [List<Notification>]',
      () async {
        // Arrange
        const testException = GetScheduledNotificationsException(
          message: 'message',
          statusCode: '500',
        );
        when(
          () => localDataSource.getScheduledNotifications(),
        ).thenThrow(testException);

        // Act
        final result = await repositoryImpl.getScheduledNotifications();

        // Assert
        expect(
          result,
          Left<Failure, void>(
            GetScheduledNotificationsFailure.fromException(
              testException,
            ),
          ),
        );

        verify(
          () => localDataSource.getScheduledNotifications(),
        ).called(1);

        verifyNoMoreInteractions(localDataSource);
      },
    );
  });
}
