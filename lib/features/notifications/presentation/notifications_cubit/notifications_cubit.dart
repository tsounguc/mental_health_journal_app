import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mental_health_journal_app/core/services/service_locator.dart';
import 'package:mental_health_journal_app/features/notifications/domain/entities/notification_entity.dart';
import 'package:mental_health_journal_app/features/notifications/domain/use_cases/cancel_notification.dart';
import 'package:mental_health_journal_app/features/notifications/domain/use_cases/get_scheduled_notifications.dart';
import 'package:mental_health_journal_app/features/notifications/domain/use_cases/schedule_notification.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'notifications_state.dart';

class NotificationsCubit extends Cubit<NotificationsState> {
  NotificationsCubit({
    required ScheduleNotification scheduleNotification,
    required CancelNotification cancelNotification,
    required GetScheduledNotifications getNotifications,
    // required SharedPreferences prefs,
  })  : _scheduleNotification = scheduleNotification,
        _cancelNotification = cancelNotification,
        _getNotifications = getNotifications,
        // _prefs = prefs,
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
      (success) async {
        emit(const NotificationScheduled());
        await _saveNotificationSettings(notification);
      },
    );
  }

  Future<void> cancelNotification({
    required int id,
  }) async {
    emit(const NotificationCanceling());

    final result = await _cancelNotification(id);

    result.fold(
      (failure) => emit(NotificationsError(message: failure.message)),
      (success) async {
        emit(const NotificationCanceled());
        await _clearNotificationSettings();
      },
    );
  }

  Future<void> getScheduledNotifications() async {
    emit(const FetchingNotifications());

    final result = await _getNotifications();

    result.fold(
      (failure) => emit(NotificationsError(message: failure.message)),
      (notifications) async {
        final (isEnabled, hour, minute) = await _loadNotificationSettings();
        emit(
          NotificationSettingsLoaded(
            isEnabled: isEnabled,
            scheduledTime: DateTime(0, 1, 1, hour, minute),
          ),
        );
      },
    );
  }

  /// **Save Notification Settings (Time & Enabled Status)**
  Future<void> _saveNotificationSettings(NotificationEntity notification) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notifications_enabled', true);
    await prefs.setInt('notification_hour', notification.scheduledTime.hour);
    await prefs.setInt('notification_minute', notification.scheduledTime.minute);
  }

  /// **Load Notification Settings**
  Future<(bool, int, int)> _loadNotificationSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final isEnabled = prefs.getBool('notifications_enabled') ?? false;
    final hour = prefs.getInt('notification_hour') ?? 8;
    final minute = prefs.getInt('notification_minute') ?? 0;
    return (isEnabled, hour, minute);
    // emit(
    //   NotificationSettingsLoaded(
    //     isEnabled: isEnabled,
    //     scheduledTime: DateTime(0, 1, 1, hour, minute),
    //   ),
    // );
  }

  /// **Clear Notification Settings**
  Future<void> _clearNotificationSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('notifications_enabled');
    await prefs.remove('notification_hour');
    await prefs.remove('notification_minute');
  }
}
