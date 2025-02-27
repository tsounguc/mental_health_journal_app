import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mental_health_journal_app/features/notifications/domain/entities/notification_entity.dart';
import 'package:mental_health_journal_app/features/notifications/domain/use_cases/cancel_notification.dart';
import 'package:mental_health_journal_app/features/notifications/domain/use_cases/get_scheduled_notifications.dart';
import 'package:mental_health_journal_app/features/notifications/domain/use_cases/schedule_notification.dart';

part 'notifications_state.dart';

class NotificationsCubit extends Cubit<NotificationsState> {
  NotificationsCubit({
    required ScheduleNotification scheduleNotification,
    required CancelNotification cancelNotification,
    required GetScheduledNotifications getNotifications,
  })  : _scheduleNotification = scheduleNotification,
        _cancelNotification = cancelNotification,
        _getNotifications = getNotifications,
        super(NotificationsInitial());

  final ScheduleNotification _scheduleNotification;
  final CancelNotification _cancelNotification;
  final GetScheduledNotifications _getNotifications;

  Future<void> scheduleNotification({
    required NotificationEntity notification,
  }) async {
    emit(const NotificationScheduling());

    final result = await _scheduleNotification(notification);

    result.fold(
      (failure) => emit(NotificationsError(message: failure.message)),
      (success) => emit(const NotificationScheduled()),
    );
  }

  Future<void> cancelNotification({
    required int id,
  }) async {
    emit(const NotificationCanceling());

    final result = await _cancelNotification(id);

    result.fold(
      (failure) => emit(NotificationsError(message: failure.message)),
      (success) => emit(const NotificationCanceled()),
    );
  }

  Future<void> getScheduledNotifications() async {
    emit(const FetchingNotifications());

    final result = await _getNotifications();

    result.fold(
      (failure) => emit(NotificationsError(message: failure.message)),
      (notifications) => emit(
        NotificationsFetched(
          notifications: notifications,
        ),
      ),
    );
  }
}
