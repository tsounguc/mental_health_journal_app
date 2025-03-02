import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mental_health_journal_app/core/errors/exceptions.dart';
import 'package:mental_health_journal_app/core/services/notifications_service/notifications_service.dart';
import 'package:mental_health_journal_app/features/notifications/data/data_sources/notification_local_data_source.dart';
import 'package:mental_health_journal_app/features/notifications/data/models/notification_model.dart';
import 'package:mental_health_journal_app/features/notifications/domain/entities/notification_entity.dart';
import 'package:mocktail/mocktail.dart';

class MockNotificationsPlugin extends Mock implements NotificationsService {}

void main() {
  late NotificationsService notificationsPlugin;
  late NotificationLocalDataSourceImpl localDataSourceImpl;

  final testNotification = NotificationModel.empty();

  setUp(() async {
    notificationsPlugin = MockNotificationsPlugin();
    localDataSourceImpl = NotificationLocalDataSourceImpl(
      notificationPlugin: notificationsPlugin,
    );
    registerFallbackValue(testNotification);
    registerFallbackValue(testNotification.scheduledTime);
  });

  test(
    'given NotificationLocalDataSourceImpl '
    'when instantiated '
    'then instance should be a subclass of [NotificationLocalDataSource]',
    () {
      // Arrange
      // Act
      // Assert
      expect(localDataSourceImpl, isA<NotificationLocalDataSource>());
    },
  );

  group('scheduleNotification - ', () {
    test(
      'given NotificationLocalDataSourceImpl, '
      'when [NotificationLocalDataSourceImpl.scheduleNotification] is called '
      'then schedule notification and complete successfully',
      () async {
        // Arrange
        when(
          () => notificationsPlugin.scheduleNotification(
            id: any(named: 'id'),
            title: any(named: 'title'),
            body: any(named: 'body'),
            date: any(
              named: 'date',
            ),
          ),
        ).thenAnswer((_) async => Future.value());

        // Act
        final methodCall = localDataSourceImpl.scheduleNotification;

        // Assert
        expect(methodCall(testNotification), completes);
        verify(
          () => notificationsPlugin.scheduleNotification(
            id: testNotification.id,
            title: testNotification.title,
            body: testNotification.body,
            date: testNotification.scheduledTime,
          ),
        ).called(1);
        verifyNoMoreInteractions(notificationsPlugin);
      },
    );

    test(
      'given NotificationLocalDataSourceImpl, '
      'when [NotificationLocalDataSourceImpl.scheduleNotification] call unsuccessful '
      'then throw [ScheduleNotificationException]',
      () async {
        // Arrange
        const testException = ScheduleNotificationException(
          message: 'message',
          statusCode: 'UNKNOWN_ERROR',
        );
        when(
          () => notificationsPlugin.scheduleNotification(
            id: any(named: 'id'),
            title: any(named: 'title'),
            body: any(named: 'body'),
            date: any(
              named: 'date',
            ),
          ),
        ).thenThrow(testException);

        // Act
        final methodCall = localDataSourceImpl.scheduleNotification;

        // Assert
        expect(
          () async => methodCall(testNotification),
          throwsA(isA<ScheduleNotificationException>()),
        );
        verify(
          () => notificationsPlugin.scheduleNotification(
            id: testNotification.id,
            title: testNotification.title,
            body: testNotification.body,
            date: testNotification.scheduledTime,
          ),
        ).called(1);
        verifyNoMoreInteractions(notificationsPlugin);
      },
    );
  });

  group('cancelNotification - ', () {
    test(
      'given NotificationLocalDataSourceImpl, '
      'when [NotificationLocalDataSourceImpl.cancelNotification] is called '
      'then schedule notification and complete successfully',
      () async {
        // Arrange
        when(
          () => notificationsPlugin.cancelNotification(any()),
        ).thenAnswer((_) async => Future.value());

        // Act
        final methodCall = localDataSourceImpl.cancelNotification;

        // Assert
        expect(methodCall(testNotification.id), completes);
        verify(
          () => notificationsPlugin.cancelNotification(
            testNotification.id,
          ),
        ).called(1);
        verifyNoMoreInteractions(notificationsPlugin);
      },
    );

    test(
      'given NotificationLocalDataSourceImpl, '
      'when [NotificationLocalDataSourceImpl.cancelNotification] call unsuccessful '
      'then throw [CancelNotificationException]',
      () async {
        // Arrange
        const testException = CancelNotificationException(
          message: 'message',
          statusCode: 'UNKNOWN_ERROR',
        );
        when(
          () => notificationsPlugin.cancelNotification(any()),
        ).thenThrow(testException);

        // Act
        final methodCall = localDataSourceImpl.cancelNotification;

        // Assert
        expect(
          () async => methodCall(testNotification.id),
          throwsA(isA<CancelNotificationException>()),
        );
        verify(
          () => notificationsPlugin.cancelNotification(
            testNotification.id,
          ),
        ).called(1);
        verifyNoMoreInteractions(notificationsPlugin);
      },
    );
  });
  group('getScheduledNotifications - ', () {
    test(
      'given NotificationLocalDataSourceImpl '
      'when [NotificationLocalDataSourceImpl.getScheduledNotifications] is called '
      'then return [List<NotificationEntity>]',
      () async {
        // Arrange
        when(
          () => notificationsPlugin.getScheduledNotifications(),
        ).thenAnswer(
          (_) async => <PendingNotificationRequest>[],
        );
        // Act
        final result = await localDataSourceImpl.getScheduledNotifications();

        // Assert
        expect(result, isA<List<NotificationEntity>>());
        verify(
          () => notificationsPlugin.getScheduledNotifications(),
        ).called(1);
        verifyNoMoreInteractions(notificationsPlugin);
      },
    );

    test(
      'given NotificationLocalDataSourceImpl '
      'when [NotificationLocalDataSourceImpl.getScheduledNotifications] call unsuccessful '
      'then throw [GetScheduledNotificationsException]',
      () async {
        // Arrange
        const testException = GetScheduledNotificationsException(
          message: 'message',
          statusCode: 'statusCode',
        );
        when(
          () => notificationsPlugin.getScheduledNotifications(),
        ).thenThrow(testException);
        // Act
        final methodCall = localDataSourceImpl.getScheduledNotifications;

        // Assert
        expect(
          () async => methodCall(),
          throwsA(isA<GetScheduledNotificationsException>()),
        );
        verify(
          () => notificationsPlugin.getScheduledNotifications(),
        ).called(1);
        verifyNoMoreInteractions(notificationsPlugin);
      },
    );
  });
}
