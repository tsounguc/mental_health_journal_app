import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mental_health_journal_app/core/errors/failures.dart';
import 'package:mental_health_journal_app/features/notifications/domain/entities/notification_entity.dart';
import 'package:mental_health_journal_app/features/notifications/domain/use_cases/cancel_notification.dart';
import 'package:mental_health_journal_app/features/notifications/domain/use_cases/get_scheduled_notifications.dart';
import 'package:mental_health_journal_app/features/notifications/domain/use_cases/schedule_notification.dart';
import 'package:mental_health_journal_app/features/notifications/presentation/notifications_cubit/notifications_cubit.dart';
import 'package:mocktail/mocktail.dart';

class MockScheduleNotification extends Mock implements ScheduleNotification {}

class MockCancelNotification extends Mock implements CancelNotification {}

class MockGetScheduledNotifications extends Mock implements GetScheduledNotifications {}

// class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  late ScheduleNotification scheduleNotification;
  late CancelNotification cancelNotification;
  late GetScheduledNotifications getNotifications;
  // late SharedPreferences prefs;

  late NotificationsCubit cubit;

  final testNotification = NotificationEntity.empty();
  final testResponse = [NotificationEntity.empty()];

  setUp(() {
    scheduleNotification = MockScheduleNotification();
    cancelNotification = MockCancelNotification();
    getNotifications = MockGetScheduledNotifications();
    // prefs = MockSharedPreferences();

    cubit = NotificationsCubit(
      scheduleNotification: scheduleNotification,
      cancelNotification: cancelNotification,
      getNotifications: getNotifications,
      // prefs: prefs,
    );
  });

  setUpAll(() {
    registerFallbackValue(testNotification);
  });

  tearDown(() {
    cubit.close();
  });

  test(
    'given NotificationsCubit '
    'when cubit is instantiated '
    'then state should be [NotificationsInitial]',
    () async {
      // Arrange
      // Act
      // Assert
      expect(cubit.state, NotificationsInitial());
    },
  );

  group('ScheduleNotification - ', () {
    final tScheduleNotificationFailure = ScheduleNotificationFailure(
      message: 'message',
      statusCode: 500,
    );
    blocTest<NotificationsCubit, NotificationsState>(
      'given NotificationsCubit '
      'when [ScheduleNotification] is called '
      'then emit [NotificationScheduling, NotificationScheduled]',
      build: () {
        when(
          () => scheduleNotification(any()),
        ).thenAnswer((_) async => const Right(null));
        return cubit;
      },
      act: (cubit) async => cubit.scheduleNotification(notification: testNotification),
      expect: () => [
        const NotificationScheduling(),
        const NotificationScheduled(),
      ],
      verify: (cubit) {
        verify(
          () => scheduleNotification(testNotification),
        ).called(1);
        verifyNoMoreInteractions(scheduleNotification);
      },
    );

    blocTest<NotificationsCubit, NotificationsState>(
      'given NotificationsCubit '
      'when [ScheduleNotification] call is unsuccessful '
      'then emit [NotificationScheduling, NotificationsError]',
      build: () {
        when(
          () => scheduleNotification(any()),
        ).thenAnswer((_) async => Left(tScheduleNotificationFailure));
        return cubit;
      },
      act: (cubit) => cubit.scheduleNotification(
        notification: testNotification,
      ),
      expect: () => [
        const NotificationScheduling(),
        NotificationsError(message: tScheduleNotificationFailure.message),
      ],
      verify: (bloc) {
        verify(
          () => scheduleNotification(testNotification),
        ).called(1);
        verifyNoMoreInteractions(scheduleNotification);
      },
    );
  });

  group('CancelNotification - ', () {
    final tCancelNotificationFailure = CancelNotificationFailure(
      message: 'message',
      statusCode: 500,
    );
    blocTest<NotificationsCubit, NotificationsState>(
      'given NotificationsCubit '
      'when [CancelNotification] is called '
      'then emit [NotificationCanceling, NotificationCanceled]',
      build: () {
        when(
          () => cancelNotification(any()),
        ).thenAnswer((_) async => const Right(null));
        return cubit;
      },
      act: (cubit) => cubit.cancelNotification(id: testNotification.id),
      expect: () => [
        const NotificationCanceling(),
        const NotificationCanceled(),
      ],
      verify: (cubit) {
        verify(
          () => cancelNotification(testNotification.id),
        ).called(1);
        verifyNoMoreInteractions(cancelNotification);
      },
    );

    blocTest<NotificationsCubit, NotificationsState>(
      'given NotificationsCubit '
      'when [CancelNotification] call is unsuccessful '
      'then emit [NotificationCanceling, NotificationsError]',
      build: () {
        when(
          () => cancelNotification(any()),
        ).thenAnswer((_) async => Left(tCancelNotificationFailure));
        return cubit;
      },
      act: (cubit) => cubit.cancelNotification(
        id: testNotification.id,
      ),
      expect: () => [
        const NotificationCanceling(),
        NotificationsError(message: tCancelNotificationFailure.message),
      ],
      verify: (bloc) {
        verify(
          () => cancelNotification(testNotification.id),
        ).called(1);
        verifyNoMoreInteractions(cancelNotification);
      },
    );
  });

  group('GetScheduledNotifications - ', () {
    final tGetNotificationsFailure = GetScheduledNotificationsFailure(
      message: 'message',
      statusCode: 500,
    );

    blocTest<NotificationsCubit, NotificationsState>(
      'given NotificationsCubit '
      'when [GetScheduledNotifications] is called '
      'then emit [FetchingNotifications, NotificationsFetched]',
      build: () {
        when(
          () => getNotifications(),
        ).thenAnswer((_) async => Right(testResponse));
        return cubit;
      },
      act: (cubit) => cubit.getScheduledNotifications(),
      expect: () => [
        const FetchingNotifications(),
        NotificationSettingsLoaded(isEnabled: true, scheduledTime: testNotification.scheduledTime),
      ],
      verify: (cubit) {
        verify(
          () => getNotifications(),
        ).called(1);
        verifyNoMoreInteractions(getNotifications);
      },
    );

    blocTest<NotificationsCubit, NotificationsState>(
      'given NotificationsCubit '
      'when [GetScheduledNotifications] call is unsuccessful '
      'then emit [FetchingNotifications, NotificationsError]',
      build: () {
        when(
          () => getNotifications(),
        ).thenAnswer((_) async => Left(tGetNotificationsFailure));
        return cubit;
      },
      act: (cubit) => cubit.getScheduledNotifications(),
      expect: () => [
        const FetchingNotifications(),
        NotificationsError(message: tGetNotificationsFailure.message),
      ],
      verify: (bloc) {
        verify(
          () => getNotifications(),
        ).called(1);
        verifyNoMoreInteractions(getNotifications);
      },
    );
  });
}
